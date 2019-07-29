import sys
import os
import re
import string

#==============================================================
def parseCensus (fN):

    digitCounts ={}; sumDigits = 0

    with open('%s' %fN) as f:
        for line in f:
            currentLine = line.split('\t')
            if currentLine[0] == 'State': continue
            try: currentPop = currentLine[2].split(None)[0]
            except IndexError: currentPop = line.split(None)[-1]
            firstDigit = int(currentPop[0])
            try: digitCounts[firstDigit] += 1
            except KeyError: digitCounts[firstDigit] = 1
            sumDigits += 1

    return digitCounts, sumDigits

#==============================================================
def calcStats (statsDict, sumDigits, fileName):

    resultsDict = {}

    for sD in statsDict:
        currentPercent = float(float(statsDict[sD])/float(sumDigits))
        resultsDict[sD] ={'counts':statsDict[sD],'percent':currentPercent}

    if (resultsDict[1]['percent'] >= 27.0 and resultsDict[1]['percent']) <= 33.0: benford = True
    else: benford = False

    finalDict = {'firstDigitDistribution':resultsDict, 'BenfordMatch':benford, 'file':'%s'%(fileName.split('\\')[-1])}

    return finalDict
        
#==============================================================
def real_main():

    fileName = r"C:\Users\bwils\OneDrive\Desktop\l7homework\census_2009.dms"
    digitStats, sumDigits = parseCensus(fileName)
    outputDict = calcStats(digitStats, sumDigits,fileName)

    for oD in outputDict:
        if oD == 'firstDigitDistribution':
            print (oD)
            for tL in sorted (outputDict[oD].keys()): print (tL, outputDict[oD][tL])
        else: print(oD, outputDict[oD])
    

#==============================================================
if ( __name__ == '__main__' ):
    real_main()
