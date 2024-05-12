import sys
import csv
import math

class TreeNode:
    def __init__(self, feature = None, entropy = 0, ig = 0, class_counts = None):
        self.feature = feature
        self.entropy = entropy
        self.ig = ig
        self.class_counts = class_counts if class_counts else {}
        self.children = {}

def entropy(class_counts):
    total_instances = sum(class_counts.values())
    entropy_val = 0
    for count in class_counts.values():
        if count != 0:
            probability = count / total_instances
            entropy_val -= probability * math.log2(probability)
    return entropy_val

def information_gain(data, attr_index, class_column):
    total_instances = len(data)
    attr_values = set(row[attr_index] for row in data)
    weighted_entropy_sum = 0
    for value in attr_values:
        subset = [row for row in data if row[attr_index] == value]
        subset_class_counts = {class_value: sum(1 for row in subset if row[class_column] == class_value) for class_value in set(row[class_column] for row in subset)}
        subset_entropy = entropy(subset_class_counts)
        weighted_entropy_sum += (len(subset) / total_instances) * subset_entropy
    parent_entropy = entropy({class_value: sum(1 for row in data if row[class_column] == class_value) for class_value in set(row[class_column] for row in data)})
    return parent_entropy - weighted_entropy_sum

def build_tree(data, attributes, class_column):
    class_counts = {class_value: sum(1 for row in data if row[class_column] == class_value) for class_value in set(row[class_column] for row in data)}
    parent_entropy = entropy(class_counts)
    if len(class_counts) == 1 or not attributes:
        return TreeNode(entropy = parent_entropy, class_counts = class_counts)
    best_attr, max_ig = None, -float('inf')
    for attr_index in attributes:
        ig = information_gain(data, attr_index, class_column)
        if ig > max_ig:
            best_attr, max_ig = attr_index, ig
    if max_ig <= 0:
        return TreeNode(entropy = parent_entropy, class_counts = class_counts)
    node = TreeNode(feature = best_attr, entropy = parent_entropy, ig = max_ig)
    remaining_attributes = attributes - {best_attr}
    for value in set(row[best_attr] for row in data):
        subset = [row for row in data if row[best_attr] == value]
        child = build_tree(subset, remaining_attributes, class_column)
        node.children[value] = child
    return node

def write_tree(node, file, depth=0):
    indent = "    " * depth
    if node.feature is not None:
        # print node's att, IG, entropy
        file.write(f"{indent}att{node.feature} (IG: {node.ig:.4f}, Entropy: {node.entropy:.4f})\n")
        for value, child in node.children.items():
            # each child of the node -> print condition
            file.write(f"{indent}    - att{node.feature} == {value} -\n")
            write_tree(child, file, depth + 1)
    else:
        # for leaf node -> directly print the class counts
        file.write(f"{indent}leaf {node.class_counts}\n")

def save_tree(node, output_file):
    with open(output_file, 'w') as file:
        write_tree(node, file)

def load_data(filename):
    with open(filename, 'r') as file:
        reader = csv.reader(file)
        next(reader, None)  # หkip the header
        data = [tuple(row) for row in reader]
    return data

def classify(instance, node):
    while node.children:  # if not at leaf node
        attribute_value = instance[node.feature]
        if attribute_value in node.children:
            node = node.children[attribute_value]
        else:
            # deal with missing att values in child
            return None
    # if at a leaf node
    return max(node.class_counts, key = node.class_counts.get)

def compute_accuracy(data, tree, class_column):
    correct_predictions = 0
    for instance in data:
        if classify(instance, tree) == instance[class_column]:
            correct_predictions += 1
    return correct_predictions / len(data)

def main():
    # check if it is the correct number of command line arguments
    if len(sys.argv) != 3:
        print("Usage: python3 comp_part2.py train_file output.txt")
        return
    
    # get the train file and output file from the command line arguments
    train_file, output_file = sys.argv[1], sys.argv[2]
    
    # load the data from the train file
    data = load_data(train_file)
    
    # last column is the class label, create a set of attribute indices
    attributes = set(range(len(data[0]) - 1))  # so it will be {0, 1, 2, 3} for att0, att1, att2, att3
    
    class_column = len(data[0]) - 1  # 4 given the headers: att0, att1, att2, att3, class
    
    # construct DT
    root = build_tree(data, attributes, class_column)
    accuracy = compute_accuracy(data, root, class_column)

    # save the constructed DT to the output file
    save_tree(root, output_file)
    print("successfully constructed the DT")
    print(f"the accuracy for constructed DT is{accuracy*100: .2f}")   

if __name__ == "__main__":
    main()
