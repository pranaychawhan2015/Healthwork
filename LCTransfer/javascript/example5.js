
function main()
{
    let msg = `{"Name":"message","Value":"75ff810301010b5472616e73616374696f6e01ff8200010701044e616d65010c000103416765010c000115446f63746f725f5370656369616c697a6174696f6e010c00010744697365617365010c000105456d61696c010c0001054164686172010c00010c4f7267616e697a6174696f6e010c0000004aff8201044e616d6501034167650115446f63746f725f5370656369616c697a6174696f6e0107446973656173650105456d61696c01054164686172010c4f7267616e697a6174696f6e00","Nonce":"8df8e0b98ee575c40137737f"}`

    let msg1 =  JSON.parse(msg.toString('ascii'))
    //let msg2 = JSON.parse(msg1.Value.toString('base64'))
    console.log(JSON.parse(hex_to_ascii(msg1.Value.toString('ascii'))))
}

function hex_to_ascii(str1)
    {
	    var hex  = str1.toString();
	    var str = '';
	    for (var n = 0; n < hex.length; n += 2) {
		    str += String.fromCharCode(parseInt(hex.substr(n, 2), 16));
	    }
	    return str;
    }

main()