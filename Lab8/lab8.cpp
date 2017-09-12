// g++ -std=c++11 lab8.cpp -o lab8

#include <stdio.h>
#define INT_SIZE 32

#include <cstdlib>
#include <iostream>
#include <set>
#include <sstream>
#include <string>

using std::string;

std::set<void *> visited;

// structs
struct Node {
    char seen;
    int basket;
    int dirt;
    int id_size;
    int *identity;
    int num_children;
    Node *children[4];
};

struct Baskets {
    int num_found;
    Node *basket[10];
};

// Lab 7 functions
int
detect_parity(int number) {
    int bits_counted = 0;
    int return_value = 1;
    for (int i = 0; i < INT_SIZE; i++) {
        int bit = (number >> i) & 1;
        if (bit) {
            bits_counted++;
        }
    }
    if (bits_counted % 2) {
        return_value = 0;
    }
    return return_value;
}

int
max_conts_bits_in_common(int a, int b) {
    int bits_seen = 0;
    int max_seen = 0;
    int c = a & b;
    for (int i = 0; i < INT_SIZE; i++) {
        int bit = (c >> i) & 1;
        if (bit == 1) {
            bits_seen++;
        } else {
            if (bits_seen > max_seen) {
                max_seen = bits_seen;
            }
            bits_seen = 0;
        }
    }
    if (bits_seen > max_seen) {
        max_seen = bits_seen;
    }
    return max_seen;
}

int
twisted_sum_array(int *v, int length) {
    int sum = 0;
    for (int i = 0; i < length; i++) {
        if (v[length - 1 - i] & 1) {
            sum /= 2;
        }
        sum += v[i];
    }
    return sum;
}

int
accumulate(int total, int value) {
    if (max_conts_bits_in_common(total, value) >= 2) {
        total = total | value;
    } else if (detect_parity(value) == 0) {
        total = total + value;
    } else {
        total = total * value;
    }
    return total;
}

int turns[4] = {1, 0, -1, 0}; // Declared as a global
int
calculate_identity(int *v, int size) {
    int dist = size;
    int total = 0;
    int idx = -1;
    turns[1] = size;
    turns[3] = -size;
    while (dist > 0) {
        for (int i = 0; i < 4; i++) {
            for (int j = 0; j < dist; j++) {
                idx = idx + turns[i];
                total = accumulate(total, v[idx]);
                v[idx] = total;
            }
            if (i % 2 == 0) {
                dist--;
            }
        }
    }
    return twisted_sum_array(v, size * size);
}

// Lab 8.1 functions
int
get_num_carrots(Node *spot) {
    if (spot == NULL) {
        return 0;
    }
    // Inverts the first and third byte.
    unsigned int dig = spot->dirt ^ 0x00ff00ff;
    // Circular shifts the bytes left one.
    dig = ((dig & 0xffffff) << 8) | ((dig & 0xff000000) >> 24);
    return spot->basket ^ dig;
}

void
pick_best_k_baskets(int k, Baskets *baskets) {
    if (baskets == NULL) {
        return;
    }
    for (int i = 0; i < k; i++) {
        for (int j = baskets->num_found - 1; j > i; j--) {
            if (get_num_carrots(baskets->basket[j - 1]) <
                get_num_carrots(baskets->basket[j])) {
                // Swaps values stored at j-1 and j in place.
                // The address stored in basket array is 32 bits
                // (i.e. You do NOT need to do any casting in MIPS.)
                baskets->basket[j] = (Node *)((intptr_t)baskets->basket[j] ^
                                              (intptr_t)baskets->basket[j - 1]);
                baskets->basket[j - 1] = (Node *)((intptr_t)baskets->basket[j] ^
                                                  (intptr_t)baskets->basket[j - 1]);
                baskets->basket[j] = (Node *)((intptr_t)baskets->basket[j] ^
                                              (intptr_t)baskets->basket[j - 1]);
            }
        }
    }
}

// Lab 8.2 functions
int
get_secret_id(int k, Baskets *baskets) {
    if (baskets == NULL) {
        return 0;
    }
    int secret_id = 0;
    for (int i = 0; i < k; i++) {
        secret_id += calculate_identity(baskets->basket[i]->identity,
                                        baskets->basket[i]->id_size);
    }
    return secret_id;
}

void
collect_baskets(int max_baskets, Node *spot, Baskets *baskets) {
    if (spot == NULL || baskets == NULL || spot->seen == 1) {
        return;
    }
    spot->seen = 1;
    for (int i = 0; i < spot->num_children && baskets->num_found < max_baskets;
         i++) {
        collect_baskets(max_baskets, spot->children[i], baskets);
    }
    if (baskets->num_found < max_baskets && get_num_carrots(spot) > 0) {
        baskets->basket[baskets->num_found] = spot;
        baskets->num_found++;
    }
    return;
}

int
search_carrot(int max_baskets, int k, Node *root, Baskets *baskets) {
    if (root == NULL || baskets == NULL) {
        return 0;
    }
    baskets->num_found = 0;
    for (int i = 0; i < max_baskets; i++) {
        baskets->basket[i] = NULL;
    }
    collect_baskets(max_baskets, root, baskets);
    pick_best_k_baskets(k, baskets);
    return get_secret_id(k, baskets);
}

// print functions
bool
should_skip(void *p) {
    return !visited.insert(p).second;
}

string
ptr_or_name(void *p, string name) {
    if (name != "") {
        return name;
    }

    std::stringstream ss;
    ss << p;
    return ss.str();
}

string
print_int_array(int *arr, int size, string name = "") {
    if (arr == NULL) {
        return "0";
    }

    bool extra_newline = name != "";
    name = ptr_or_name(arr, name);

    printf("%s: .word", name.c_str());

    for (int i = 0; i < size; i++) {
        printf(" %d", arr[i]);
    }

    printf("\n");

    if (extra_newline) {
        printf("\n");
    }

    return name;
}

string
print_node(Node *n, string name = "") {
    if (n == NULL) {
        return "0";
    }

    bool extra_newline = name != "";
    name = ptr_or_name(n, name);

    string arr = print_int_array(n->identity, n->id_size * n->id_size);

    printf("%s : .word", name.c_str());

    printf(" %d %d %d %d", (int)n->seen, n->basket, n->dirt, n->id_size);
    printf(" %s", arr.c_str());
    printf(" %d", n->num_children);

    for (int i = 0; i < 4; i++) {
        printf(" %s", ptr_or_name(n->children[i], "").c_str());
    }

    printf("\n");

    if (extra_newline) {
        printf("\n");
    }

    return name;
}

string
print_baskets(Baskets *b, string name = "") {
    if (b == NULL) {
        return "0";
    }

    bool extra_newline = name != "";
    name = ptr_or_name(b, name);

    string basket[10];
    for (int i = 0; i < b->num_found; i++) {
        basket[i] = print_node(b->basket[i]);
    }

    if (extra_newline) {
        printf("\n");
    }

    return name;
}

// test cases
void
test_get_num_carrots() {
    Node *n1 = new Node{0, 0, 0x1ff00ff, 0, NULL, 0, {NULL}};
    printf("get_num_carrots test case 1 is: %d\n", get_num_carrots(n1));
    // print_node(n1, "test_get_num_carrots_n1");

    Node *n2 = new Node{0, 0xffffff, 0xff00, 0, NULL, 0, {NULL}};
    printf("get_num_carrots test case 2 is: %d\n", get_num_carrots(n2));
    // print_node(n2, "test_get_num_carrots_n2");

    printf("\n");
}

void
test_pick_best_k_baskets() {
    Node *n1 = new Node{0, 0, 0x1ff00ff, 0, NULL, 0, {NULL}};
    Node *n2 = new Node{0, 0, 0x2ff00ff, 0, NULL, 0, {NULL}};
    Node *n3 = new Node{0, 0, 0x3ff00ff, 0, NULL, 0, {NULL}};
    Node *n4 = new Node{0, 0, 0x4ff00ff, 0, NULL, 0, {NULL}};
    Node *n5 = new Node{0, 0, 0x5ff00ff, 0, NULL, 0, {NULL}};
    Node *n6 = new Node{0, 0, 0x6ff00ff, 0, NULL, 0, {NULL}};
    Node *n7 = new Node{0, 0, 0x7ff00ff, 0, NULL, 0, {NULL}};
    Node *n8 = new Node{0, 0, 0x8ff00ff, 0, NULL, 0, {NULL}};

    Baskets *four_baskets = new Baskets{4, {n1, n2, n3, n4}};
    pick_best_k_baskets(4, four_baskets);
    printf("pick_best_k_baskets(4, four_baskets) is: \n");
    print_baskets(four_baskets, "test_pick_best_k_baskets_four_baskets");

    Baskets *eight_baskets = new Baskets{8, {n1, n3, n5, n7, n2, n4, n6, n8}};
    pick_best_k_baskets(4, eight_baskets);
    printf("pick_best_k_baskets(4, eight_baskets) is: \n");
    print_baskets(eight_baskets, "test_pick_best_k_baskets_eight_baskets");

}

void
test_get_secret_id() {
    Node *n1 = new Node{0, 0, 0x1ff00ff, 1, new int[1]{1}, 0, {NULL}};
    Node *n2 = new Node{0, 0, 0x2ff00ff, 1, new int[1]{2}, 0, {NULL}};
    Node *n3 = new Node{0, 0, 0x3ff00ff, 1, new int[1]{3}, 0, {NULL}};
    Node *n4 = new Node{0, 0, 0x4ff00ff, 1, new int[1]{4}, 0, {NULL}};
    Baskets *four_baskets = new Baskets{4, {n1, n2, n3, n4}};
    printf("get_secret_id(2, four_baskets) is: %d\n",
           get_secret_id(2, four_baskets));
    printf("get_secret_id(4, four_baskets) is: %d\n",
           get_secret_id(4, four_baskets));
    // print_baskets(four_baskets, "test_get_secret_id_four_baskets");

    printf("\n");
}

void
test_collect_baskets() {
    Node *n1 = new Node{0, 0, 0x1ff00ff, 0, NULL, 0, {NULL}};
    Node *n2 = new Node{0, 0, 0x2ff00ff, 0, NULL, 0, {NULL}};
    Node *n3 = new Node{0, 0, 0x3ff00ff, 0, NULL, 2, {n1, n2}};
    Node *n4 = new Node{0, 0, 0x4ff00ff, 0, NULL, 0, {NULL}};
    Node *n5 = new Node{0, 0, 0x5ff00ff, 0, NULL, 2, {n3, n4}};
    // print_node(n5, "test_collect_baskets_n5");
    Baskets *two_baskets = new Baskets{0, {NULL}};
    collect_baskets(3, n5, two_baskets);
    printf("collect_baskets(3, n5, two_baskets) is: \n");
    print_baskets(two_baskets, "test_collect_baskets_two_baskets");

    Node *n6 = new Node{0, 0, 0x1ff00ff, 0, NULL, 0, {NULL}};
    Node *n7 = new Node{0, 0, 0x2ff00ff, 0, NULL, 1, {n6}};
    Node *n8 = new Node{0, 0, 0x3ff00ff, 0, NULL, 1, {n6}};
    Node *n9 = new Node{0, 0, 0x4ff00ff, 0, NULL, 2, {n7, n8}};
    // print_node(n9, "test_collect_baskets_n9");
    Baskets *four_baskets = new Baskets{0, {NULL}};
    collect_baskets(4, n9, four_baskets);
    printf("collect_baskets(4, n9, four_baskets) is: \n");
    print_baskets(four_baskets, "test_collect_baskets_four_baskets");
}

void
test_search_carrot() {
    Node *n1 = new Node{0, 0, 0x1ff00ff, 1, new int[1]{1}, 0, {NULL}};
    Node *n2 = new Node{0, 0, 0x2ff00ff, 1, new int[1]{2}, 0, {NULL}};
    Node *n3 = new Node{0, 0, 0x3ff00ff, 1, new int[1]{3}, 2, {n1, n2}};
    Node *n4 = new Node{0, 0, 0x4ff00ff, 1, new int[1]{4}, 0, {NULL}};
    Node *n5 = new Node{0, 0, 0x5ff00ff, 1, new int[1]{5}, 2, {n3, n4}};
    // print_node(n5, "test_collect_baskets_n5");
    Baskets *baskets = new Baskets{0, {NULL}};
    printf("search_carrot(4, 2, n5, baskets) is: %d\n",
           search_carrot(4, 2, n5, baskets));

    Node *n6 = new Node{0, 0, 0x1ff00ff, 1, new int[1]{1}, 0, {NULL}};
    Node *n7 = new Node{0, 0, 0x2ff00ff, 1, new int[1]{2}, 1, {n6}};
    Node *n8 = new Node{0, 0, 0x3ff00ff, 1, new int[1]{3}, 1, {n6}};
    Node *n9 = new Node{0, 0, 0x4ff00ff, 1, new int[1]{4}, 2, {n7, n8}};
    // print_node(n9, "test_search_carrot_n9");
    printf("search_carrot(4, 3, n9, baskets) is: %d\n",
           search_carrot(4, 3, n9, baskets));

    // print_baskets(baskets, "test_search_carrot_baskets");

    printf("\n");
}

int
main() {
    test_get_num_carrots();
    test_pick_best_k_baskets();
    test_get_secret_id();
    test_collect_baskets();
    test_search_carrot();

    return 0;
}
