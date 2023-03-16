from collections import deque

dists = {}

valve = "BB"
# dists["BB"] == {"BB": 0, "AA": 0, ....}

dists[valve] = {valve: 0, "AA": 0}

visited = {valve} # {"BB"}

queue = deque([(0,valve)])
# queue:
# 1
# BB, CC, DD JJ
# pop = BB
distance, position = queue.popleft()

# BB -> CC, DD, JJ

# if CC is in visited -> go to next neighbour
# else add to visited

# BB:
# CC -> visited
# CC has flowrate? (flowrate != 0)
# distance from BB -> CC = distance(0) + 1

# dists[BB][CC] = 1
# dists[BB] = {BB: 0, AA: 0, CC: 1}

# DD = 0
# queue.append((0 + 1, DD)) == (1, DD)

# dists == {
#   {BB, {JJ: 1, CC: 3, DD: 4}}
#   {CC, {TT: } ....}
#   {DD ....}
# }

print(queue)