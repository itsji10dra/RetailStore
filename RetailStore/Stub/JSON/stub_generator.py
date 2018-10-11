import os
import json

products_directory = 'Products'
details_directory = 'ProductDetails/'

os.makedirs(os.path.dirname(details_directory), exist_ok=True)

for filename in os.listdir(products_directory):
	with open(os.path.join(products_directory, filename)) as file:
	    data = json.load(file)

	results = data['result']

	expectedOutput = {
	    'page': 0,
	    'pageSize': 0,
	    'totalPageCount': 0,
	    'result': {
	    	'id': 0,
        	'sectionId': 0,
        	'title': '',
        	'thumbImage': '',
        	'price': 0.0,
	        'images': [
	            'http://www.example.com/big-image-1.png',
	            'http://www.example.com/big-image-2.png',
	            'http://www.example.com/big-image-3.png',
	            'http://www.example.com/big-image-4.png',
	            'http://www.example.com/big-image-5.png',
	        ],
	        'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent a metus ullamcorper, varius sapien at, rutrum ligula. Nam finibus nisi id nunc semper, eget mattis lacus tincidunt. Fusce convallis pellentesque nunc ac aliquet. Morbi a libero non quam elementum venenatis at at turpis. Vestibulum cursus vitae ligula dignissim blandit. Nam tincidunt lectus nec dignissim pulvinar. Curabitur id tortor vel est vulputate placerat. In elementum consequat quam, id luctus urna venenatis vitae.\n\nUt interdum augue eu faucibus hendrerit. Phasellus fermentum vel mauris eget venenatis. Sed nec sagittis justo. Aenean in ultrices odio. Ut eget velit efficitur, rhoncus urna in, mattis lorem. Duis nec euismod arcu, ut dictum ligula. Nunc laoreet libero nec nibh viverra vehicula. Etiam mattis erat felis, in porta nisl mollis eu. Praesent placerat risus sed molestie porta. Pellentesque dictum lacus eu mi sodales, auctor mollis elit lacinia. Quisque velit sem, bibendum viverra tempor a, molestie eu turpis. Duis convallis justo orci.\n\nPraesent iaculis lorem vitae dui vehicula auctor. Nam molestie erat in lacinia iaculis. Ut a urna sit amet velit sollicitudin mattis dapibus vel justo. Suspendisse rhoncus enim et diam lacinia, et efficitur dui egestas. Vestibulum ullamcorper, leo et vehicula convallis, odio diam tincidunt velit, et varius odio purus malesuada nisi. Vestibulum vitae commodo sapien. Suspendisse potenti. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce facilisis dolor sed diam condimentum, vitae vehicula elit tincidunt. Etiam mauris justo, pellentesque ac finibus mollis, egestas non diam. Fusce mauris lacus, pretium sit amet tortor at, venenatis dapibus arcu.\n\nSed vitae vestibulum nisi. In at nulla elit. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Cras eu purus ex. Proin aliquam convallis ligula, vel tincidunt augue tristique in. Maecenas metus dui, scelerisque vel lacus id, rutrum faucibus risus. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer tristique viverra nisi, in vestibulum lectus varius at. Nunc vitae turpis vitae mauris pulvinar tincidunt. Phasellus dictum orci id elit porta, eu condimentum tortor pulvinar.\n\nNulla euismod dictum porta. Sed hendrerit, felis eu imperdiet sodales, metus nisi congue ligula, eget imperdiet tortor risus sed purus. Integer venenatis lacinia gravida. Aliquam pellentesque gravida ligula, sed tincidunt dolor varius et. Donec ultrices pretium sodales. Morbi eu elit sit amet est dapibus tristique et suscipit purus. Nam porta lectus eros, ac fringilla erat tempus eget. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Cras fermentum porta luctus. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Morbi vel porttitor enim, et pellentesque eros. Fusce vitae facilisis metus. Pellentesque ac urna a eros gravida aliquam.',
	    }
	}

	for result in results:
		output = expectedOutput
		output['result']['id'] = result['id']
		output['result']['sectionId'] = result['sectionId']
		output['result']['title'] = result['title']
		output['result']['thumbImage'] = result['thumbImage']
		output['result']['price'] = result['price']

		filename = 'ProductDetails-Id' + str(result['id']) + '.json'
		path = os.path.join(details_directory, filename)
		with open(path, 'w') as file:
			file.write(json.dumps(output, indent=4))
