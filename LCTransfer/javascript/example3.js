
	// JavaScript program to print all root to leaf paths
	
	class Node
	{
		constructor(data) {
		this.left = null;
		this.right = null;
		this.data = data;
		}
	}
	
	let root;
		
	/* Given a binary tree, print out all of its root-to-leaf
	paths, one per line. Uses a recursive helper to do the work.*/
	function printPaths(node)
	{
		let path = new Array(1000);
		printPathsRecur(node, path, 0);
	}
	
	/* Recursive helper function -- given
	a node, and an array containing
	the path from the root node up to but
	not including this node,
	print out all the root-leaf paths. */
	function printPathsRecur(node, path, pathLen)
	{
		if (node == null)
			return;
	
		/* append this node to the path array */
		path[pathLen] = node.data;
		pathLen++;
	
		/* it's a leaf, so print the path that led to here */
		if (node.left == null && node.right == null)
			printArray(path, pathLen);
		else
			{
			/* otherwise try both subtrees */
			printPathsRecur(node.left, path, pathLen);
			printPathsRecur(node.right, path, pathLen);
		}
	}
	
	/* Utility that prints out an array on a line */
	function printArray(ints, len)
	{
		let i;
		for (i = 0; i < len; i++)
			console.log(ints[i] + " ");
		console.log("\n");
	}
	
    function main(){
        
        root = new Node(1);
        root.left = new Node(2);
        root.right = new Node(3);
        root.left.left = new Node(4);
        root.left.right = new Node(5);
    
        /* Print all root-to-leaf paths of the input tree */
        printPaths(root);
    }

    main();
