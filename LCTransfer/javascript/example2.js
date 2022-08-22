
// JavaScript implementation of the approach

// Tree Structure
class nptr
{
constructor(c) {
    this.left = null;
    this.right = null;
    this.data = c;
    }
}

// Function to create new node
function newNode(c)
{
    let n = new nptr(c);
    return n;
}

// Function to build Expression Tree
function build(s)
{

    // Stack to hold nodes
    let stN = [];

    // Stack to hold chars
    let stC = [];
    let t, t1, t2;

    // Prioritising the operators
    let p = new Array(123);
    p['+'.charCodeAt()] = p['-'.charCodeAt()] = 1;
    p['/'.charCodeAt()] = p['*'.charCodeAt()] = 2;
    p['^'.charCodeAt()] = 3;
    p[')'.charCodeAt()] = 0;

    for (let i = 0; i < s.length; i++)
    {
        if (s[i] == '(')
        {

            // Push '(' in char stack
            stC.push(s[i]);
        }

        // Push the operands in node stack
        else if ((/[a-zA-Z]/).test(s[i]))
        {
            t = newNode(s[i]);
            stN.push(t);
        }
        else if (p[s[i].charCodeAt()] > 0)
        {

            // If an operator with lower or
            // same associativity appears
            while (stC.length != 0 && stC[stC.length - 1] != '('
                && ((s[i] != '^' &&
                p[stC[stC.length - 1].charCodeAt()] >=
                p[s[i].charCodeAt()])
                    || (s[i] == '^'&&
                    p[stC[stC.length - 1].charCodeAt()] >
                    p[s[i].charCodeAt()])))
            {

                // Get and remove the top element
                // from the character stack
                t = newNode(stC[stC.length - 1]);
                stC.pop();

                // Get and remove the top element
                // from the node stack
                t1 = stN[stN.length - 1];
                stN.pop();

                // Get and remove the currently top
                // element from the node stack
                t2 = stN[stN.length - 1];
                stN.pop();

                // Update the tree
                t.left = t2;
                t.right = t1;

                // Push the node to the node stack
                stN.push(t);
            }

            // Push s[i] to char stack
            stC.push(s[i]);
        }
        else if (s[i] == ')')
        {
            while (stC.length != 0 &&
            stC[stC.length - 1] != '(')
            {
                t = newNode(stC[stC.length - 1]);
                stC.pop();
                t1 = stN[stN.length - 1];
                stN.pop();
                t2 = stN[stN.length - 1];
                stN.pop();
                t.left = t2;
                t.right = t1;
                stN.push(t);
            }
            stC.pop();
        }
    }
    t = stN[stN.length - 1];
    return t;
}

// Function to print the post order
// traversal of the tree
let data = ""
function postorder(root)
{
    if (root != null)
    {
        postorder(root.left);
        postorder(root.right);
        console.log(root.data);
        data += root.data
    }
}

function main(){
    let s = "civilEngineer AND (LaborRepresentative AND (supplier OR TrustedEntity))";
    s = "(" + s;
    s += ")";
    let root = build(s);
    console.log(root.data)
    // Function call
    postorder(root);
    console.log("data" + data)
    data = "";
}

main();

