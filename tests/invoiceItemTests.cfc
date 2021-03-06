component extends="mxunit.framework.TestCase" {

	public void function setup() {

		stripe = new stripe.stripe( apiKey = request.apiKey, includeRaw = true );
		customerObject = stripe.createCustomer( description = 'Test Customer' );

	}

	public void function testCreateInvoiceItem() {

		var result = stripe.createInvoiceItem( customer = customerObject.id, amount = 5000, description = "You lose! $50 more!", metadata = { foo = "bar" } );

		debug( customerObject );
		debug( result );

		assertEquals( 200, result.status_code, "expected a 200 status" );
		assertEquals( "invoiceitem", result.object, "invoiceitem object was not returned" );
		assertEquals( { foo = "bar" }, result.metadata, "correct metadata was not returned" );

	}

	public void function testCreateInvoiceItemNegativeAmount() {

		var result = stripe.createInvoiceItem( customer = customerObject.id, amount = -1000, description = "You win! $10 off!" );

		debug( customerObject );
		debug( result );

		assertEquals( 200, result.status_code, "expected a 200 status" );
		assertEquals( "invoiceitem", result.object, "invoiceitem object was not returned" );
		assertEquals( -1000, result.amount, "correct invoiceitem amount was not returned" );

	}

	public void function testGetInvoiceItem() {

		var invoiceitemObject = stripe.createInvoiceItem( customer = customerObject.id, amount = 5000, description = "You lose! $50 more!" );
		var result = stripe.getInvoiceItem( invoiceitemObject.id );

		debug( customerObject );
		debug( invoiceitemObject );
		debug( result );

		assertEquals( 200, result.status_code, "expected a 200 status" );
		assertEquals( invoiceitemObject.id, result.id, "correct invoiceitem object was not returned" );

	}
	
	public void function testUpdateInvoiceItem() {

		var invoiceUpdate = { amount = 2000, description = "Changed the amount!", metadata = { test = "value", foo = "" } };

		var invoiceitemObject = stripe.createInvoiceItem( customer = customerObject.id, amount = 5000, description = "You lose! $50 more!", metadata = { foo = "bar" } );
		var result = stripe.updateInvoiceItem( id = invoiceitemObject.id, amount = invoiceUpdate.amount, description = invoiceUpdate.description, metadata = invoiceUpdate.metadata );

		debug( customerObject );
		debug( invoiceitemObject );
		debug( result );

		assertEquals( 200, result.status_code, "expected a 200 status" );
		assertEquals( invoiceitemObject.id, result.id, "correct invoiceitem object was not returned" );
		assertEquals( invoiceUpdate.amount, result.amount, "correct invoiceitem amount was not returned" );
		assertEquals( { test = "value" }, result.metadata, "correct invoiceitem metadata was not returned" );

	}
	
	public void function testDeleteInvoiceItem() {

		var invoiceitemObject = stripe.createInvoiceItem( customer = customerObject.id, amount = 3000, description = "You lose! $30 more!" );
		var result = stripe.deleteInvoiceItem( invoiceitemObject.id );

		debug( customerObject );
		debug( invoiceitemObject );
		debug( result );

		assertEquals( 200, result.status_code, "expected a 200 status" );
		assertEquals( invoiceitemObject.id, result.id, "correct invoiceitem object was not returned" );
		assertTrue( result.deleted, "invoiceitem was not deleted" );

	}

	public void function testListInvoiceItems() {

		var invoiceitemOne = { customer = customerObject.id, amount = 3000, description = "You lose! $30 more!" };
		var invoiceitemTwo = { customer = customerObject.id, amount = -1000, description = "You win! $10 off!" };

		var invoiceitemOneObject = stripe.createInvoiceItem( argumentCollection = invoiceItemOne );
		var invoiceitemTwoObject = stripe.createInvoiceItem( argumentCollection = invoiceItemTwo );
		var result = stripe.listInvoiceItems( limit = 2, customer = customerObject.id );

		debug( invoiceitemOneObject );
		debug( invoiceitemTwoObject );
		debug( result );

		assertEquals( 200, result.status_code, "expected a 200 status" );
		assertTrue( arrayLen( result.data ) == 2, "invoiceitems are not listed" );

	}
	
}