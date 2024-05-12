import sys
import csv
import numpy as np
from collections import Counter

def min_max(data):
    mins = np.min(data, axis=0)
    maxs = np.max(data, axis=0)
    return (data - mins) / (maxs - mins)

def euclidean_dist(x1, x2):
    return np.sqrt(np.sum((x1 - x2) ** 2))

def k_nearest_neighb(trainData, testData, k):
    predict = []
    for test_instance in testData:
        distances = []
        for train_instance in trainData:
            dist = euclidean_dist(test_instance[:-1], train_instance[:-1])
            distances.append((train_instance, dist))
        distances.sort(key=lambda x: x[1])
        neighbors = [neighbor[0] for neighbor in distances[:k]]
        majority_vote = Counter([neighbor[-1] for neighbor in neighbors]).most_common(1)[0][0]
        predict.append((test_instance[-1], majority_vote, [dist for _, dist in distances[:k]]))
    return predict

def LoadData(filename):
    with open(filename, 'r') as file:
        reader = csv.reader(file)
        next(reader)  # skip the header row as they are just label
        data = [list(map(float, row)) for row in reader]
    return data

def write_output(predict, output_filename, k):
    with open(output_filename, 'w', newline='') as file:
        writer = csv.writer(file)
        header = ['y', 'predicted_y'] + [f'distance{i+1}' for i in range(k)]
        writer.writerow(header)
        for pred in predict:
            row = [pred[0], pred[1]] + pred[2]
            writer.writerow(row)

def main():
    if len(sys.argv) != 5:
        print("Usage: python3 comp.py train_file test_file output_file k_value")
        sys.exit(1)

    train_file = sys.argv[1]
    test_file = sys.argv[2]
    output_file = sys.argv[3]
    k = int(sys.argv[4])

    trainData = LoadData(train_file)
    testData = LoadData(test_file)

    # normalise the data
    trainData = min_max(trainData)
    testData = min_max(testData)

    predict = k_nearest_neighb(trainData, testData, k)

    # write output output file
    write_output(predict, output_file, k)

    # accuracy percentage
    correct = sum(1 for pred in predict if pred[0] == pred[1])
    accuracy = correct / len(predict) * 100
    print(f"The acccuracy is {accuracy:.2f}%")

if __name__ == "__main__":
    main()