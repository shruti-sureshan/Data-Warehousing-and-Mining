from collections import Counter, OrderedDict
import itertools
from pprint import pprint


MIN_SUPPORT_COUNT = 2
MIN_CONFIDENCE = 0.70
debug_print = print

def load_dataset():
    return [
        {'I1', 'I3', 'I4'}, 
        {'I2', 'I3', 'I5'},
        {'I1', 'I2', 'I3', 'I5'},
        {'I2', 'I5'}
    ]

def print_dict(d):
    for k, v in d.items():
        print(k, ':', v)
    return len(k)


def create_c1(freq):
    freq1 = freq.copy()
    for k,v in freq1.items():
        if v < MIN_SUPPORT_COUNT:
            del freq[k]
    return freq


def support_count(item):
    return sum(1 for row in load_dataset() if item.issubset( row ))


def confidence(rule):
    # rule: 2-tuple
    # where rule[0] = set of items
    #       rule[1] = set of items
    return support_count(rule[0] | rule[1]) / support_count(rule[1])


def apriori(data, min_sup=MIN_SUPPORT_COUNT, min_conf=MIN_CONFIDENCE):
    d = [item for sublist in data for item in sublist]
    freq = OrderedDict(Counter(d).items())
    c1 = create_c1(freq)
    # debug print 
    debug_print('C1: ')
    print_dict(c1)
    comb = 2
    while True:
        c = {}
        for perm in itertools.combinations(OrderedDict(c1).keys(), comb):
            count = 0
            for row in data:
                if set(perm).issubset(row):
                    count += 1
                if count >= min_sup:
                    c[perm] = count
        if len(c.keys()) <= 2:
            break
        comb += 1
    debug_print("Final Candidate: ")
    k_size = print_dict(c) # final candidate table

    debug_print('Association rules:')
    rules = []
    
    for itemset in c:
        for i in range(1, k_size):
            for item in itertools.combinations(itemset, r=i):
                lhs, rhs = set(item), set(itemset) - set(item)
                rules.append( (lhs, rhs) )

    for rule in rules:
        debug_print(rule[0], '->', rule[1], end=' ')
        debug_print('Confidence:', '{:5.2f}'.format( confidence(rule) ))

    debug_print('Chosen rules:')
    chosen_rules = [rule for rule in rules if confidence(rule) >= min_conf]
    for rule in chosen_rules:
        debug_print(rule[0], '->', rule[1], end=' ')
        debug_print('Confidence:', '{:5.2f}'.format( confidence(rule) ))

         

if __name__ == '__main__':
    c = apriori(data=load_dataset())

