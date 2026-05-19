class SimkinECCAp2compiler(object):

    def load_recipes(self):
        recipe_l = 64
        with open('data\\SimkinECCA.txt') as f:
            rows=f.read().split("\n")
            for row in rows:
                sections = row.split("--")
                if sections[0]!="":
                    recipe_l += 1
                    name = sections[2].strip()
                    self.name2l[name] = chr(recipe_l)
                    self.l2name[chr(recipe_l)] = name
                    self.recipes[name] = (sections[0].strip(),sections[1].strip())

    def pack_letters(self, str):
        last_ch = ""
        last_cnt = 0
        res = ""
        #print(f"packing letters {str}")
        for ch in str:
            if ch==last_ch:
                last_cnt += 1
            else:
                if last_cnt>0:
                    res += last_ch
                if last_cnt>2:
                    res += f"*{last_cnt}"
                elif last_cnt==2:
                    res += last_ch
                last_cnt = 1
                last_ch = ch
        if last_cnt>0:
            res += last_ch
        if last_cnt>2:
            res += f"*{last_cnt}"
        elif last_cnt==2:
            res += last_ch
        return res

    # add delay component to recipes and
    # do Bellman Ford on recipes to calculate optimal movement
    def make_move_table(self):
        movekeys = []
        plusMove, plusEff, minusMove, minusEff = "",0,"",0
        for recipekey in self.recipes:
            recipe = self.recipes[recipekey][0].split(" ")
            info = self.recipes[recipekey][1].split("l") # works only for 270 degree recipes
            sg = int(info[0])
            delay = -120*sg
            if recipe[0][0]=="+": # the only not synced recipe
                delay += int(recipe[0][1:])
                self.recipes[recipekey]=(self.recipes[recipekey][0],self.recipes[recipekey][1],delay,sg)
            elif recipe[0][0]=="[":
                for td_i in range(1,len(recipe)):
                    if recipe[td_i][0]=="(":
                        delay+=int(recipe[td_i][1:-1])
                    elif recipe[td_i][0]=="[":
                        #synchronization not included in delay info
                        #but only allows inserting +8X ... should be preceded by (A) matching the [b] rounding
                        delay = delay #syntax trash
                    else:
                        delay+=int(recipe[td_i])
                self.recipes[recipekey]=(self.recipes[recipekey][0],self.recipes[recipekey][1],delay,sg)
            if len(info)==1:
                movekeys.append(recipekey)
                if delay>plusEff:
                    plusEff=delay
                    plusMove=self.name2l[recipekey]
                if delay<minusEff:
                    minusEff=delay
                    minusMove=self.name2l[recipekey]

        if plusEff != 1:
            print(f"Expected +1 be the only plus move! {plusEff}")
        if minusEff != -150:
            print(f"Expected -150 be the best minus move! {minusEff}")
        print(f"long range best moves {plusMove}={self.l2name[plusMove]} {minusMove}={self.l2name[minusMove]}")

        #BellmanFord
        for i in range(8):
            # changing the collision timeposition by 0
            self.m[f"[{i}]_0"]=("", 0, 0)
        plusPeriod,minusPeriod=8,-144
        maxPlus,minMinus=1+plusPeriod,-1+minusPeriod # -150 for faster stabilisation
        toFindPeriod = True
        orig_moves = [k for k in movekeys]
        print ("table computation starts")
        progress = True
        def updateIfBetter(key, move, cost, sgliders):
            if (not key in self.m) or (self.m[key][1] > cost):
                self.m[key] = (move, cost, sgliders)
                return True
            elif self.m[key][1] == cost:
                #we prefere plus moves at the end
                for i in range(1,len(self.m[key][0])):
                    if i>len(move):
                        break
                    lo = self.m[key][0][-i]
                    ln = move[-i]
                    if lo!=ln:
                        if ln==plusMove:
                            #print(f"A-tail better {self.pack_letters(move)} then {self.pack_letters(self.m[key][0])} i,lo,ln:{i},{lo},{ln}")
                            self.m[key] = (move, cost, sgliders)
                        return ln==plusMove
            return False

        while toFindPeriod:
            progress = True
            #print ("Finding period")
            while progress:
                progress = False
                old_moves = [k for k in self.m]
                #print ("Doing progress")
                for edge in orig_moves:
                    erecipe = self.recipes[edge][0].split(" ")
                    edge_str = self.name2l[edge]
                    sg = self.recipes[edge][3]
                    delay = self.recipes[edge][2]
                    ecost = 120*sg + delay # delay has 120*sg subtracted
                    #print(f"edge {edge} '{edge_str}' {delay} {ecost}")
                    if erecipe[0][0]=="+":
                        for src_vertex in old_moves:
                            src = src_vertex.split("_")
                            pos = int(src[1])+delay
                            if pos<=maxPlus:
                                key = f"{src[0]}_{pos}"
                                sgliders = self.m[src_vertex][2] + sg
                                cost = self.m[src_vertex][1] + ecost
                                move = self.m[src_vertex][0] + edge_str
                                new = updateIfBetter(key, move, cost, sgliders)
                                if not progress and new:
                                #if new:
                                    #print (f"progress moves[{key}]=({self.pack_letters(move)}, {cost})")
                                    progress = True
                    else:
                        sync = int(erecipe[0][1:-1])
                        for src_vertex in old_moves:
                            src = src_vertex.split("_")
                            vpos = int(src[0][1:-1])+int(src[1])
                            if vpos % 8 == sync:
                                pos = int(src[1])+delay
                                if pos>=minMinus-150:
                                    key = f"{src[0]}_{pos}"
                                    sgliders = self.m[src_vertex][2] + sg
                                    cost = self.m[src_vertex][1] + ecost
                                    move = self.m[src_vertex][0] + edge_str
                                    new = updateIfBetter(key, move, cost, sgliders)
                                    if not progress and new:
                                    #if new:
                                        #print (f"progress moves[{key}]=({self.pack_letters(move)}, {cost})")
                                        progress = True
            for n in range(minMinus,maxPlus+1):
                row = f"_{n}"
                for s in range(8):
                    key = f"[{s}]_{n}"
                    if key in self.m:
                        row += f" {self.pack_letters(self.m[key][0])}({self.m[key][1]},{self.m[key][2]})"
                    else:
                        row += " ?"
                #print(row)
            toFindPeriod = False
            for n in range(maxPlus,maxPlus-plusPeriod-1,-1):
                if toFindPeriod:
                    break
                for s in range(8):
                    toFindPeriod = True
                    key = f"[{s}]_{n}"
                    if key in self.m:
                        if (self.m[key][0].find(plusMove*8)>=0):
                            toFindPeriod = False
                    if toFindPeriod:
                        maxPlus = n + plusPeriod + 1
                        print (f"maxPlus changed to {n}+{plusPeriod+1}={maxPlus}")
                        break
            toFindPlus = toFindPeriod
            toFindPeriod = False
            for n in range(minMinus,minMinus-minusPeriod+1):
                if toFindPeriod:
                    break
                for s in range(8):
                    toFindPeriod = True
                    key = f"[{s}]_{n}"
                    if key in self.m:
                        if (self.m[key][0].find(minusMove+plusMove*6)>=0):
                            toFindPeriod = False
                    if toFindPeriod:
                        minMinus = n + minusPeriod - 1
                        print (f"minMinus changed to {n}+{minusPeriod-1}={minMinus}")
                        break
            toFindPeriod = toFindPeriod or toFindPlus
            #toFindPeriod = toFindPlus
        all_moves = [k for k in self.m]
        for k in all_moves:
            pos = int(k.split("_")[1])
            if (pos<minMinus) or (pos>maxPlus):
                del self.m[k]
        self.mMinMinus = minMinus
        self.mMaxPlus = maxPlus
        self.mMinusPeriod = minusPeriod
        self.mPlusPeriod = plusPeriod
        self.mMinus = minusMove
        self.mPlus = plusMove

        print ("get_move table:")
        for n in range(minMinus-10,maxPlus+11):
            row = f"_{n}"
            for s in range(8):
                move = self.get_move(s,n)
                row += f" {self.pack_letters(move[0])}({move[1]},{move[2]})"
            print(row)

    #let us make table of optpimal single emissions. The problem is we do not know the continuation and the total cost depends on the followup.
    #fortunately for the same number of used simkin gliders the recipe able to finish in shorter time (able to do earlier collision)
    #is definitely better (it can delay the followup to match the other)
    #so we can store the best recipes for each number of destroyed simkin gliders
    #the best recipe using the minimal number of simkin gliders should be stored, (followup with increased lane)
    #but for recipes using more simkin gliders (followup with decreased lane), they should be compared to smaller number
    #of simkin gliders followed by a "B/C/D" move. If they are dominated, there is no need to store them.
    def make_l_table(self):
        def dominated(sync,muster,questioned):
            #print(f"dom [{sync}],({self.pack_letters(muster[0])},{muster[1]},{muster[2]}),({self.pack_letters(questioned[0])},{questioned[1]},{questioned[2]})")
            if muster[2]>questioned[2]: #actually we would not ask
                return False
            elif muster[2]==questioned[2]: #actually we would not ask either
                return muster[1]<=questioned[1]
            else:
                dist = questioned[1]-muster[1] - 120*(questioned[2]-muster[2])
                move = self.get_move((sync+muster[1])%8,dist)
                #print (f"is {(self.pack_letters(muster[0]),muster[1],muster[2])} dominating {(self.pack_letters(questioned[0]),questioned[1],questioned[2])} ... dist{dist} {move[1]}+{muster[1]}={move[1]+muster[1]}")
                return move[1]+muster[1]<=questioned[1]

        def updateIfBetter(key, move, cost, sgliders):
            #print(f"uib {key},{self.pack_letters(move)},{cost},{sgliders}")
            cur_moveitem = (move, cost, sgliders)
            if (not key in self.l):
                self.l[key]=[cur_moveitem]
                return True
            inserted, try_insert = False, True
            for r in range(len(self.l[key])):
                if try_insert:
                    if self.l[key][r][2] > cur_moveitem[2]:
                        cur_moveitem, self.l[key][r], inserted = self.l[key][r], cur_moveitem, True
                    elif self.l[key][r][2] == cur_moveitem[2]:
                        if self.l[key][r][1] > cur_moveitem[1]:
                            self.l[key][r], inserted, try_insert = cur_moveitem, True, False
                        else:
                            return False

            if try_insert:
                if not dominated(int(key[1]),self.l[key][-1], cur_moveitem):
                    self.l[key].append(cur_moveitem)
                    inserted = True
            if inserted:
                #print (f"recheck {range(1,len(self.l[key]))}")
                i=1
                while i<len(self.l[key]):
                    if dominated(int(key[1]),self.l[key][-i-1],self.l[key][-i]):
                        #print (f"removing dominated {self.l[key][-i]}, leaving {self.l[key][-i-1]}")
                        del self.l[key][-i]
                        if i>1:
                            i-=1
                    else:
                        i+=1
            return inserted

        for recipekey in self.recipes:
            info = self.recipes[recipekey][1].split("l") # works only for 270 degree recipes
            if len(info)==2: #single glider emissions
                ginfo = info[1].split(",")
                phase = "eo"[int(ginfo[0])%2]
                lane = int(ginfo[1])
                sync = int(self.recipes[recipekey][0][1])
                sg = self.recipes[recipekey][3]
                cost = self.recipes[recipekey][2]+120*sg # delay has 120*sg subtracted
                updateIfBetter(f"{[sync]}_{phase}{lane}",self.name2l[recipekey],cost,sg)
                updateIfBetter(f"{[sync]}_b{lane}",self.name2l[recipekey],cost,sg)
        plusPeriod,minusPeriod=2,-36
        maxPlus,minMinus=self.mMaxPlus//4,self.mMinMinus//4
        prevMaxPlus,prevMinMinus=-1,0
        toFindPeriod = True
        orig_moves = [k for k in self.l]
        print ("table computation starts")
        def lane_recipes(lane):
            print (f"lane {lane}")
            for omove in orig_moves:
                #print(omove)
                os=int(omove[1])
                op=omove[4]
                olane=int(omove[5:])
                shift = lane-olane
                if shift%2 == 0:
                    for oinfo in self.l[omove]:
                        for s in range(8):
                            minfo = self.get_move(s,os-s+4*shift)
                            updateIfBetter(f"{[s]}_{op}{lane}",minfo[0]+oinfo[0],minfo[1]+oinfo[1],minfo[2]+oinfo[2])

        def print_ltable(phase,minM,maxP):
            print (f"l_table {phase}({minM},{maxP})")
            for n in range(minM,maxP+1):
                row = f"_{phase}{n}"
                for s in range(8):
                    key = f"[{s}]_{phase}{n}"
                    if key in self.l:
                        alt = ""
                        for lmove in self.l[key]:
                            alt += f",{self.pack_letters(lmove[0])}({lmove[1]},{lmove[2]})"
                        row += " "+alt[1:]
                    else:
                        row += " ?"
                print(row)

        while toFindPeriod:
            for lane in range(prevMaxPlus+1,maxPlus+1):
                 lane_recipes(lane)
            for lane in range(prevMinMinus-1,minMinus-1,-1):
                 lane_recipes(lane)

            #for phase in "beo":
            #    print_ltable(phase,minMinus,maxPlus)
            prevMinMinus,prevMaxPlus = minMinus,maxPlus

            toFindPeriod = False
            for n in range(maxPlus,maxPlus-plusPeriod-1,-1):
                if toFindPeriod:
                    break
                for s in range(8):
                    if toFindPeriod:
                        break
                    for phase in "beo":
                        toFindPeriod = True
                        key = f"[{s}]_{phase}{n}"
                        if key in self.l:
                            for option in self.l[key]:
                                if (option[0].find(self.mPlus*8)>=0):
                                    toFindPeriod = False
                        if toFindPeriod:
                            maxPlus = n + plusPeriod + 1
                            print (f"maxPlus changed to {n}({s}{phase})+{plusPeriod+1}={maxPlus}")
                            break
            toFindPlus = toFindPeriod
            toFindPeriod = False
            for n in range(minMinus,minMinus-minusPeriod+1):
                if toFindPeriod:
                    break
                for s in range(8):
                    if toFindPeriod:
                        break
                    for phase in "beo":
                        toFindPeriod = True
                        key = f"[{s}]_{phase}{n}"
                        if key in self.l:
                            for option in self.l[key]:
                                if (option[0].find(self.mMinus+self.mPlus*6)>=0):
                                    toFindPeriod = False
                        if toFindPeriod:
                            minMinus = n + minusPeriod - 1
                            print (f"minMinus changed to {n}({s}{phase})+{minusPeriod-1}={minMinus}")
                            break
            toFindPeriod = toFindPeriod or toFindPlus
            #toFindPeriod = toFindPlus

        self.lMinMinus = minMinus
        self.lMaxPlus = maxPlus
        self.lMinusPeriod = minusPeriod
        self.lPlusPeriod = plusPeriod

        print ("get_loptions tables:")
        for phase in "beo":
            for n in range(minMinus-10,maxPlus+11):
                row = f"_{phase}{n}"
                for s in range(8):
                    alt = ""
                    for lmove in self.get_loptions(s,phase,n):
                        alt += f",{self.pack_letters(lmove[0])}({lmove[1]},{lmove[2]})"
                    row += " "+alt[1:]
                print(row)

    # let us do not consider building and destroying the simkin gun and expecting the recipe contain lanes not interacting with the simkin gun
    # do not use anchor moves and their destroyal at the first try
    def __init__(self, initial_direction=1):

        self.recipes = {} # imported base recipes "{name}"->(exttimedeltas, description, delay, sgliders) -- delay, sgliders added by make_move_table
        self.m = {} # arm moves "[{sync}]_{delta}"->(letterstring, cost, sgliders)
        self.l = {} # single emissions which could be optimal "[{sync}]_{phase}{lanedist of correct parity}"->[(letterstring, cost, sgliders)]
        # delay = cost - 120*sgliders ... (change of cur)
        # the m,l would be formulated in recipe names as the "possibly optimal" recipes would be after some preperiod periodic with respect to both 
        #increasing/decreasing lane distances, the recipes would be tabulated till the period appears and function replaying to requests in the periodic portion would be answered
        #using a finite portion of the table. We know the most efficient move considering self.cur decrease would be "m2", so when m2 m2 apears in the recipe, we expect we are already
        #in the cycle. If it happened for 144 units (the move size) we are in the periodic portion of the function
        #synchronization wait would be on the other end of the table.
        #self.[X].minindex, self.[X].maxindex for X in "m", "l" would be used by the tablereading function.
        self.l2name = {} # translation from compact form to original names
        self.name2l = {}  # translation from original names to compact form
        # names2exttimedeltas transation to recipe including (a)[b]+c operands
        # jointimedeltas transation to recipe possibly including [b]+c only on start and (a) only on both ends
        self.load_recipes()
        self.make_move_table()
        self.make_l_table()
        self.prev_goptions = [] # TODO to be used for combined emissions
        #Following structures are "doubled", second version corresponds to switched o<>e phases on input % means we could use results from the other branch as well ... (current pattern is p1)
        self.cur = [0,0] # position of the collision of the simking glider with gliders sent at next_available_tick would happen in "1/8 fd"
        # glider lanes in recipes are relative to 2*(self.cur//8)
        self.delayed2, self.delayed1 = [{},{}], [{},{}] # portions of candidate salvas not yet decided to connect to the recipe, delayed2 does not contain last 2 gliders, delayed1 does not contain last glider (the glider currently considered)
        self.subresults = [""]
        self.delayed1[0][0],self.delayed1[1][0]=("0:",0),("0:",0)
        self.output = ["",""] # to be made by self.flush from subresults

        # curAfterLastEmission -> (letterstring,cost)
        self.delayed = [{},{}] # curerntly working on similarly as self.delayed1, self.delayed2 to be "rotated" after all options are processed
        # curAfterLastEmission -> ((predecessorkey,predecessorlevel,letterstring after predecessor),cost)

    #(letterstring, cost, sgliders)
    def get_move(self, sync, dist):
        #print (f"get_move({sync},{dist})")
        if dist < self.mMinMinus:
            e = (dist - self.mMinMinus) // (-self.mMinusPeriod)
            moveBase = self.m[f"[{sync}]_{dist+e*self.mMinusPeriod}"]
            rpos = moveBase[0].find(self.mMinus+self.mPlus*6)
            move = moveBase[0][:rpos] + (self.mMinus+self.mPlus*6)*(-e) + moveBase[0][rpos:]
            cost = moveBase[1]-e*96
            sg = moveBase[2]-e*2
            ret=(move, cost, sg)
        elif dist > self.mMaxPlus:
            e = (self.mMaxPlus - dist) // self.mPlusPeriod
            moveBase = self.m[f"[{sync}]_{dist+e*self.mPlusPeriod}"]
            rpos = moveBase[0].find(self.mPlus*8)
            move = moveBase[0][:rpos] + (self.mPlus*8)*(-e) + moveBase[0][rpos:]
            cost = moveBase[1]-e*8
            sg = moveBase[2]-e*0
            ret=(move, cost, sg)
        else:
            ret = self.m[f"[{sync}]_{dist}"]
        return ret
    #[(letterstring, cost, sgliders)]
    def get_loptions(self, sync, phase, lanedist):
        #print (f"get_move({sync},{dist})")
        options=[]
        if lanedist < self.lMinMinus:
            e = (lanedist - self.lMinMinus) // (-self.lMinusPeriod)
            key = f"[{sync}]_{phase}{lanedist+e*self.lMinusPeriod}"
            for o in self.l[key]:
                rpos = o[0].find(self.mMinus+self.mPlus*6)
                move = o[0][:rpos] + (self.mMinus+self.mPlus*6)*(-e) + o[0][rpos:]
                cost = o[1]-e*96
                sg = o[2]-e*2
                options.append((move,cost,sg))
        elif lanedist > self.lMaxPlus:
            e = (self.lMaxPlus - lanedist) // self.lPlusPeriod
            key = f"[{sync}]_{phase}{lanedist+e*self.lPlusPeriod}"
            for o in self.l[key]:
                rpos = o[0].find(self.mPlus*8)
                move = o[0][:rpos] + (self.mPlus*8)*(-e) + o[0][rpos:]
                cost = o[1]-e*8
                sg = o[2]-e*0
                options.append((move, cost, sg))
        else:
            options = self.l[f"[{sync}]_{phase}{lanedist}"]
        return options

    #[(letterstring, cost, sgliders, lane0)] to be shifted to p_lane latter
    def get_llpreoptions(self, p_laneMod2, lanedif, pphase, phase):
        #there is curreently at most one match, so we do not bother with multiplicity
        name = f"ll{p_laneMod2}_{lanedif}"
        if name in self.recipes:
            #simple match
            print (f"ll match {name}")
            recipe = self.recipes[name]
            info = recipe[1].split("l")
            if pphase!="b" and pphase!="eo"[int(info[1].split(",")[0])%2]:
                print (f"pphase wrong {pphase} {'eo'[int(info[1].split(',')[0])%2]}")
                return []
            if phase!="b" and phase!="eo"[int(info[2].split(",")[0])%2]:
                print (f"phase wrong {phase} {'eo'[int(info[2].split(',')[0])%2]}")
                return []
            return [(self.name2l[name],recipe[2]+120*recipe[3],recipe[3],int(info[1].split(",")[1]))]
        name = f"ll{p_laneMod2}" #there is only one such recipe, otherwise we should make changes there
        if name in self.recipes:
            print (f"ll match {name}")
            recipe = self.recipes[name]
            info = recipe[1].split("l")
            if pphase!="b" and pphase!="eo"[int(info[1].split(",")[0])%2]:
                print (f"pphase wrong {pphase} {'eo'[int(info[1].split(',')[0])%2]}")
                return []
            baselanedif = int(info[1].split(",")[2]) # more general alternative would to have baselanedif in _o,_e parts
            if lanedif<baselanedif:
                print (f"lanedif too small")
                return []
            name2 = f"ll{p_laneMod2}_{'eo'[lanedif%2]}"
            recipe2 = self.recipes[name2]
            info2 = recipe2[1].split("l")
            if phase!="b" and phase!="eo"[int(info2[1].split(",")[0])%2]:
                print (f"phase wrong {phase} {'eo'[int(info2[1].split(',')[0])%2]}")
                return []
            print (f"lanedif {lanedif} baselanedif {baselanedif} dif//2 {(lanedif-baselanedif)//2}")
            minfo = self.get_move(0,8*((lanedif-baselanedif)//2)) #positive moves do not depend on sync (the sync is 0)
            return [(self.name2l[name]+minfo[0]+self.name2l[name2],
                recipe[2]+120*recipe[3]+minfo[1]+recipe2[2]+120*recipe2[3],
                recipe[3]+minfo[2]+recipe2[3],
                int(info[1].split(",")[1]))]
        return []

    #[(letterstring, cost, sgliders)]
    def get_lloption(self, sync, lane0evendist, llpreoption):
        print (f"get_lloption({sync},{lane0evendist},({self.pack_letters(llpreoption[0])},{llpreoption[1]},{llpreoption[2]},{llpreoption[3]}))")
        os = int(self.recipes[self.l2name[llpreoption[0][0]]][0][1])
        shift = lane0evendist - llpreoption[3]
        minfo = self.get_move(sync,os-sync+4*shift)
        return (minfo[0]+llpreoption[0],minfo[1]+llpreoption[1],minfo[2]+llpreoption[2])

    def pack_loptions(self,loptions):
        res=" "
        for loption in loptions:
            res+=f"({self.pack_letters(loption[0])},{loption[1]},{loption[2]}),"
        return res[:-1]

    def letters2names(self, letter_string):
        names = ""
        for l in letter_string:
            names += self.l2name[l]+" "
        return names[:-1]

    def names2exttimedeltas(self, names_string):
        names = names_string.split(" ")
        recipe = []
        for name in names:
            recipe.append(self.recipes[name][0])
        return " ".join(recipe)

    def jointimedeltas(self, ext_td):
        etds = ext_td.split(" ")
        current_parenthesis = 0
        current_plus = 0
        synced = False
        started = False
        current_reminder = 0
        tds = []
        for etd in etds:
            if etd[0]=="(":
                if not synced:
                    print("consecutive parenthesis!")
                else:
                    current_parenthesis = int(etd[1:-1])
                    synced = False
            elif etd[0]=="[":
                if synced:
                    print("consecutive square brackets!")
                if not started:
                    if current_parenthesis>0:
                        tds.append(f"({current_parenthesis + current_plus})")
                    elif current_plus>0:
                        tds.append(f"+{current_plus}")
                    tds.append(etd)
                    started = True
                else:
                    td = current_parenthesis + current_plus
                    rem = (int(etd[1:-1]) - td - current_reminder) % 8
                    tds.append(f"{td+rem}")
                current_reminder = int(etd[1:-1])
                current_parenthesis = 0
                current_plus = 0
                synced = True
            elif etd[0]=="+":
                if synced:
                    print("+ at synced state!")
                current_plus += int(etd[1:])
            else:
                if not synced:
                    print("exact delay when not synced!")
                delay = int(etd)
                tds.append(etd)
                current_reminder += delay
        if current_parenthesis > 0:
            if current_parenthesis>0:
                tds.append(f"({current_parenthesis + current_plus})")
        return " ".join(tds)

    def pack_delayed1(self, delayed):
        res=""
        for key,value in delayed.items():
            res += f" {key}:({self.pack_letters(value[0])},{value[1]})"
        return res

    def pack_subresults(self):
        res=""
        for i in range(len(self.subresults)):
            s_sr=self.subresults[i].split(":")
            if len(s_sr)>1:
                res+=f"\n{i}={s_sr[0]}:{self.pack_letters(s_sr[1])}"
        return res[1:]

    def process_goptions(self,goptions):

        phaseswitching = {"b0":"b", "b1":"b", "o0":"o", "o1":"e", "e0":"e", "e1":"o"}

        self.delayed=[{},{}]
        def updateIfBetter(key, phaseswitch, move, cost):
            #print(f"uib {key},{self.pack_letters(move)},{cost}")
            if (not key in self.delayed[phaseswitch]):
                self.delayed[phaseswitch][key] = (move, cost)
                return True
            if self.delayed[phaseswitch][key][1] > cost:
                self.delayed[phaseswitch][key] = (move, cost)
                return True
            else:
                return False
        print(f"process_options {goptions} len(delayed2) {len(self.delayed2[0])},{len(self.delayed2[1])} len(delayed1) {len(self.delayed1[0])},{len(self.delayed1[1])}")
        print(f"subresults {self.pack_subresults()}")
        print (f"delayed 2[0]{self.pack_delayed1(self.delayed2[0])}")
        print (f"delayed 2[1]{self.pack_delayed1(self.delayed2[1])}")
        print (f"delayed 1[0]{self.pack_delayed1(self.delayed1[0])}")
        print (f"delayed 1[1]{self.pack_delayed1(self.delayed1[1])}")
        for phaseswitch in range(2):
            for pgoption in self.prev_goptions:
                if len(pgoption):
                    #TODO % on pgoption phaseswitch is it ok?
                    pphase, p_lane = phaseswitching[f"{pgoption[0]}{phaseswitch}"], int(pgoption[1:])
                    for goption in goptions:
                        if len(goption):
                            phase, lane = phaseswitching[f"{goption[0]}{phaseswitch}"], int(goption[1:])
                            lanedif = lane-p_lane
                            llpreoptions = self.get_llpreoptions(p_lane%2,lanedif,pphase,phase)
                            print (f"llpreoptions: {llpreoptions}")
                            for llpreoption in llpreoptions:
                                print(f"trying ({self.pack_letters(llpreoption[0])},{llpreoption[1]},{llpreoption[2]},{llpreoption[3]})")
                                for key, value in self.delayed2[phaseswitch].items():
                                    lloption = self.get_lloption(key%8,p_lane-2*(key//8),llpreoption)
                                    ncost = value[1] + lloption[1]
                                    ncur = key + lloption[1] - 120*lloption[2]
                                    nmove = (key, 2, lloption[0]) # real update would be during step forward
                                    updateIfBetter(ncur, phaseswitch, nmove, ncost)

            # we plan to use delayed2 in near future using ll emissions as well
            # after procossing possible double emissions
            for goption in goptions:
                if len(goption):
                    phase, lane = phaseswitching[f"{goption[0]}{phaseswitch}"], int(goption[1:])
                    for key, value in self.delayed1[phaseswitch].items():
                        loptions = self.get_loptions(key%8, phase, lane-2*(key//8))
                        print(f"loptions [{key%8}]_{phase}{lane-2*(key//8)}: {self.pack_loptions(loptions)}")
                        for loption in loptions:
                            ncost = value[1] + loption[1]
                            ncur = key + loption[1] - 120*loption[2]
                            nmove = (key, 1, loption[0]) # real update would be during step forward
                            updateIfBetter(ncur, phaseswitch, nmove, ncost)
        self.prev_goptions = goptions

    #extends the options DAG and if it is "tally" it outputs already known
    def preprocess_glider(self, glider):
        def updateIfBetter(cur,phaseswitch,movecost):
            if not cur in self.delayed1[phaseswitch]:
                self.delayed1[phaseswitch][cur]=movecost
            elif movecost[1] < self.delayed1[phaseswitch][cur][1]:
                self.delayed1[phaseswitch][cur]=movecost

        if glider == '%':
            keys0 = self.delayed1[0].keys()
            for key1 in self.delayed1[1].keys():
                updateIfBetter(key1,0,self.delayed1[1][key1])
            for key0 in keys0:
                updateIfBetter(key0,1,self.delayed1[0][key0])
            print("done? %")
        else:
            goptions = glider.split("|")
            self.process_goptions(goptions)
            for phaseswitch in range(2):
                if len(self.delayed[phaseswitch])==1 and len(self.delayed1[phaseswitch])==1:
                    #we probably can flush known "history"
                    for key, value in self.delayed[phaseswitch].items():
                        if value[0][1] == 1: #mark of normal emission
                            print (f"partial output[{phaseswitch}] {self.pack_delayed1(self.delayed1[phaseswitch])} {key} {value}")
                            self.cur[phaseswitch] = value[0][0]
                            joiner = len(self.subresults)
                            self.subresults.append(self.delayed1[phaseswitch][self.cur[phaseswitch]][0])
                            self.delayed1[phaseswitch][value[0][0]]=(f"{joiner}:",self.delayed1[phaseswitch][value[0][0]][1])
                for key, value in self.delayed[phaseswitch].items(): #let us include the history (if not cut)
                    if value[0][1] == 1:
                        self.delayed[phaseswitch][key]=(self.delayed1[phaseswitch][value[0][0]][0]+value[0][2], value[1])
                    else:
                        #print (f"self_delayed update2 (({value[0][0]},{value[0][1]},{self.pack_letters(value[0][2])}),{value[1]}) {self.pack_delayed1(self.delayed2[phaseswitch])}")
                        self.delayed[phaseswitch][key]=(self.delayed2[phaseswitch][value[0][0]][0]+value[0][2], value[1])

            self.delayed2,self.delayed1 = self.delayed1,self.delayed
            #self.delayed2 = dict.copy(self.delayed1)
            #self.delayed1 = dict.copy(self.delayed)

    #selects the emission with minimal cost, not considering the final .cur
    def flush(self):
        for phaseswitch in range(2):
            bestkey = min(self.delayed1[phaseswitch], key=lambda x:self.delayed1[phaseswitch][x][1])
            print (f"finally {phaseswitch}: cost {self.delayed1[phaseswitch][bestkey][1]}")
            self.cur[phaseswitch] = bestkey
            output = self.delayed1[phaseswitch][bestkey][0].split(":")
            while int(output[0])>0:
                output = (self.subresults[int(output[0])]+output[1]).split(":")
            self.output[phaseswitch]=output[1]
        return

    def compile(self, gliders):

        self.cur = [0,0]
        self.subresults = [""]
        self.delayed2, self.delayed1 = [{},{}], [{},{}] # portions of candidate salvas not yet decided to connect to the recipe, delayed2 does not contain last 2 gliders, delayed1 does not contain last glider (the glider currently considered)
        self.delayed1[0][0],self.delayed1[1][0]=("0:",0),("0:",0)
        self.prev_goptions = []
        for x in gliders.split():
            self.preprocess_glider(x)
        self.flush()
        maintd,td="",""
        for phaseswitch in range(2):
            maintd = td
            print (f"{phaseswitch}: {self.pack_letters(self.output[phaseswitch])}")
            names = self.letters2names(self.output[phaseswitch])
            print (names)
            exttd = self.names2exttimedeltas(names)
            print (exttd)
            td = self.jointimedeltas(exttd)
            print (td)
        return maintd
