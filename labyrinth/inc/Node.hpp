#ifndef NODE_HPP
#define NODE_HPP

#include <tuple>

struct Node {
	int x;
	int y;

	bool operator == (Node rhs);
	bool operator != (Node rhs);
};

bool operator < (Node lhs, Node rhs) ;

#endif //NODE_HPP
