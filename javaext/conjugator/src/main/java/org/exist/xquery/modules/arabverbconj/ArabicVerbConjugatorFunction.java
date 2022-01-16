/*
 *  eXist Open Source Native XML Database
 *  Copyright (C) 2015 Loren Cahlander
 *  loren.cahlander@gmail.com
 *  http://greatlinkup.com
 *
 *  This program is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public License
 *  as published by the Free Software Foundation; either version 2
 *  of the License, or (at your option) any later version.
 *  
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Lesser General Public License for more details.
 *  
 *  You should have received a copy of the GNU Lesser General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *  
 *  $Id$
 */
package org.exist.xquery.modules.arabverbconj;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.exist.dom.QName;
import org.exist.xquery.BasicFunction;
import org.exist.xquery.Cardinality;
import org.exist.xquery.FunctionSignature;
import org.exist.xquery.XPathException;
import org.exist.xquery.XQueryContext;
import org.exist.xquery.value.FunctionParameterSequenceType;
import org.exist.xquery.value.FunctionReturnSequenceType;
import org.exist.xquery.value.Sequence;
import org.exist.xquery.value.SequenceIterator;
import org.exist.xquery.value.SequenceType;
import org.exist.xquery.value.StringValue;
import org.exist.xquery.value.Type;
import org.exist.xquery.value.ValueSequence;

/**
 * This is an example module that concatenates an input string with "Hello" showing how to create a function module.
 * 
 * Based on the echo example by Loren Cahlander
 */
public class ArabicVerbConjugatorFunction extends BasicFunction {

    @SuppressWarnings("unused")
	private final static Logger logger = LogManager.getLogger(ArabicVerbConjugatorFunction.class);

    // Cardinality possibilites: ZERO, ZERO_OR_ONE, ONE, ZERO_OR_MORE, ONE_OR_MORE
    public final static FunctionSignature signature =
		new FunctionSignature(
			new QName("arabverbconj", ArabicVerbConjugatorModule.NAMESPACE_URI, ArabicVerbConjugatorModule.PREFIX),
			"A useless example function. It just concatenates the input string with Hello.",
			new SequenceType[] { new FunctionParameterSequenceType("text", Type.STRING, Cardinality.ONE, "Input text")},
			new FunctionReturnSequenceType(Type.STRING, Cardinality.ONE, "Output text"));

	public ArabicVerbConjugatorFunction(XQueryContext context) {
		super(context, signature);
	}

	public Sequence eval(Sequence[] args, Sequence contextSequence)
		throws XPathException {

		// is argument the empty sequence?
		if (args[0].isEmpty()) {
			return Sequence.EMPTY_SEQUENCE;
		}
		
		// iterate through the argument sequence and output each item
		ValueSequence result = new ValueSequence();
		for (SequenceIterator i = args[0].iterate(); i.hasNext();) {
			String str = i.nextItem().getStringValue();
			result.add(new StringValue("Hello " + str));
		}
		return result;
	}

}
