/*
    This file is part of the Mage distribution.

    https://github.com/senselogic/QUAGE

    Copyright (C) 2017 Eric Pelzer (ecstatic.coder@gmail.com)

    Mage is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, version 3.

    Mage is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mage.  If not, see <http://www.gnu.org/licenses/>.
*/

// == LOCAL

// -- IMPORTS

import std.conv : to;
import std.regex : matchFirst, regex, Captures, Regex;
import std.stdio : writeln;
import std.string : indexOf, split, startsWith, strip;

// == GLOBAL

// -- TYPES

struct QUATERNION
{
    // -- CONSTANTS

    enum
    {
        XComponentIndex = 0,
        YComponentIndex = 1,
        ZComponentIndex = 2,
        WComponentIndex = 3,
        ComponentCount = 4
    };

    // -- ATTRIBUTES

    string[ 4 ]
        ComponentArray;

    // -- INQUIRIES

    bool IsSumComponent(
        string component
        )
    {
        return
            component.indexOf( " - " ) >= 0
            || component.indexOf( " + " ) >= 0;
    }

    // -- OPERATIONS

    void SetIdentity(
        )
    {
        ComponentArray[ XComponentIndex ] = "0.0";
        ComponentArray[ YComponentIndex ] = "0.0";
        ComponentArray[ ZComponentIndex ] = "0.0";
        ComponentArray[ WComponentIndex ] = "1.0";
    }

    // ~~

    void SetFromXRotation(
        string half_x_cosinus,
        string half_x_sinus
        )
    {
        // Turn Y axis towards Z axis.

        SetIdentity();

        ComponentArray[ XComponentIndex ] = half_x_sinus;
        ComponentArray[ WComponentIndex ] = half_x_cosinus;
    }

    // ~~

    void SetFromYRotation(
        string half_y_cosinus,
        string half_y_sinus
        )
    {
        // Turn Z axis towards X axis.

        SetIdentity();

        ComponentArray[ YComponentIndex ] = half_y_sinus;
        ComponentArray[ WComponentIndex ] = half_y_cosinus;
    }

    // ~~

    void SetFromZRotation(
        string half_z_cosinus,
        string half_z_sinus
        )
    {
        // Turn X axis towards Y axis.

        SetIdentity();

        ComponentArray[ ZComponentIndex ] = half_z_sinus;
        ComponentArray[ WComponentIndex ] = half_z_cosinus;
    }

    // ~~

    void SetFromName(
        string name
        )
    {
        ComponentArray[ 0 ] = name ~ ".X";
        ComponentArray[ 1 ] = name ~ ".Y";
        ComponentArray[ 2 ] = name ~ ".Z";
        ComponentArray[ 3 ] = name ~ ".W";
    }

    // ~~

    void SetProductQuaternion(
        QUATERNION first_quaternion,
        QUATERNION second_quaternion
        )
    {
        long
            first_component_index,
            first_vector_index,
            second_component_index,
            second_vector_index,
            sign;
        long[]
            second_component_index_array,
            sign_array;
        string
            component,
            first_component,
            second_component,
            term_component;
        
        // X = first_quaternion.W * second_quaternion.X + first_quaternion.X * second_quaternion.W + first_quaternion.Y * second_quaternion.Z - first_quaternion.Z * second_quaternion.Y;
        // Y = first_quaternion.W * second_quaternion.Y - first_quaternion.X * second_quaternion.Z + first_quaternion.Y * second_quaternion.W + first_quaternion.Z * second_quaternion.X;
        // Z = first_quaternion.W * second_quaternion.Z + first_quaternion.X * second_quaternion.Y - first_quaternion.Y * second_quaternion.X + first_quaternion.Z * second_quaternion.W;
        // W = first_quaternion.W * second_quaternion.W - first_quaternion.X * second_quaternion.X - first_quaternion.Y * second_quaternion.Y - first_quaternion.Z * second_quaternion.Z;

        second_component_index_array 
            = [ 
                0, 3, 2, 1,
                1, 2, 3, 0,
                2, 1, 0, 3,
                3, 0, 1, 2
              ];
              
        sign_array
            = [
                1, 1, 1, -1,
                1, -1, 1, 1,
                1, 1, -1, 1,
                1, -1, -1, -1
              ];

        foreach ( component_index; 0 .. ComponentCount )
        {
            component = ComponentArray[ component_index ];
            component = "0.0";

            foreach ( term_index; 0 .. ComponentCount )
            {
                first_component_index = ( 3 + term_index ) % 4;
                second_component_index = second_component_index_array[ component_index * 4 + term_index ];
                sign = sign_array[ component_index * 4 + term_index ];
                first_component = first_quaternion.ComponentArray[ first_component_index ];
                second_component = second_quaternion.ComponentArray[ second_component_index ];

                if ( first_component == "0.0" || second_component == "0.0" )
                {
                    term_component = "0.0";
                }
                else if ( first_component == "1.0" )
                {
                    term_component = second_component;
                }
                else if ( second_component == "1.0" )
                {
                    term_component = first_component;
                }
                else
                {
                    if ( IsSumComponent( first_component ) )
                    {
                        first_component = "( " ~ first_component ~ " )";
                    }

                    if ( IsSumComponent( second_component ) )
                    {
                        second_component = "( " ~ second_component ~ " )";
                    }

                    term_component = first_component ~ " * " ~ second_component;
                }

                if ( component == "0.0" )
                {
                    if ( sign > 0 || term_component == "0.0" )
                    {
                        component = term_component;
                    }
                    else
                    {
                        if ( IsSumComponent( term_component ) )
                        {
                            component = "-( " ~ term_component ~ " )";
                        }
                        else
                        {
                            component = "-" ~ term_component;
                        }
                    }
                }
                else if ( term_component != "0.0" )
                {
                    if ( sign > 0 )
                    {
                        component = component ~ " + " ~ term_component;
                    }
                    else
                    {
                        component = component ~ " - " ~ term_component;
                    }
                }
            }

            ComponentArray[ component_index ] = component;
        }
    }
    
    // ~~
    
    bool FindMatch(
        string text,
        Regex!char expression,
        ref Captures!( string, ulong ) match
        )
    {
        match = text.matchFirst( expression );

        return !match.empty();
    }
    
    // ~~
    
    string GetFixedExpression(
        string expression
        )
    {
        string
            old_expression;
        Captures!( string, ulong )
            match;
        Regex!char
            negative_addition_expression,
            negative_product_expression,
            positive_product_expression,
            positive_substraction_expression;

        negative_addition_expression = regex( `(.+)\+ -([A-Za-z0-9_\.]+.*)` );
        positive_substraction_expression = regex( `(.+)\- -([A-Za-z0-9_\.]+.*)` );
        negative_product_expression = regex( `(.+) ([A-Za-z0-9_\.]+) \* -([A-Za-z0-9_\.]+.*)` );
        positive_product_expression = regex( `(.+) -([A-Za-z0-9_\.]+) \* -([A-Za-z0-9_\.]+.*)` );
        
        do
        {
            old_expression = expression;
            
            if ( FindMatch( expression, negative_addition_expression, match ) )
            {
                expression = match[ 1 ] ~ "- " ~ match[ 2 ];
            }
            else if ( FindMatch( expression, positive_substraction_expression, match ) )
            {
                expression = match[ 1 ] ~ "+ " ~ match[ 2 ];
            }
            else if ( FindMatch( expression, negative_product_expression, match ) )
            {
                expression = match[ 1 ] ~ " -" ~ match[ 2 ] ~ " * " ~ match[ 3 ];
            }
            else if ( FindMatch( expression, positive_product_expression, match ) )
            {
                expression = match[ 1 ] ~ " " ~ match[ 2 ] ~ " * " ~ match[ 3 ];
            }
        }
        while ( expression != old_expression );
        
        return expression;
    }

    // ~~

    void Print(
        string name
        )
    {
        string
            expression;
            
        foreach ( component_index; 0 .. ComponentCount )
        {
            expression
                = name
                ~ '.'
                ~ ( "XYZW"[ component_index ] )
                ~ " = "
                ~ ComponentArray[ component_index ]
                ~ ";";
            
            writeln( GetFixedExpression( expression ) );
        }

        writeln();
    }
};

// -- FUNCTIONS
    
void main(
    string[] argument_array
    )
{
    bool
        reverse_option_is_enabled;
    long
        component_count,
        quaternion_index,
        vector_count;
    string
        argument,
        quaternion_name,
        option;
    string[]
        value_array;
    QUATERNION
        first_quaternion,
        quaternion,
        product_quaternion,
        second_quaternion;
    QUATERNION[]
        quaternion_array;

    reverse_option_is_enabled = false;

    argument_array = argument_array[ 1 .. $ ];

    while ( argument_array.length >= 1
            && argument_array[ 0 ].startsWith( "--" ) )
    {
        option = argument_array[ 0 ];

        argument_array = argument_array[ 1 .. $ ];

        if ( option == "--reverse" )
        {
            reverse_option_is_enabled = true;
        }
    }

    if ( argument_array.length >= 2 )
    {
        quaternion_name = argument_array[ 0 ];
        quaternion_array.length = argument_array.length - 1;

        foreach ( argument_index; 1 .. argument_array.length )
        {
            argument = argument_array[ argument_index ];

            if ( argument == "identity_quaternion" )
            {
                quaternion.SetIdentity();
            }
            else if ( argument == "x_rotation_quaternion" )
            {
                quaternion.SetFromXRotation( "half_x_cosinus", "half_x_sinus" );
            }
            else if ( argument == "y_rotation_quaternion" )
            {
                quaternion.SetFromYRotation( "half_y_cosinus", "half_y_sinus" );
            }
            else if ( argument == "z_rotation_quaternion" )
            {
                quaternion.SetFromZRotation( "half_z_cosinus", "half_z_sinus" );
            }
            else
            {
                quaternion.SetFromName( argument );
            }

            quaternion_array[ argument_index - 1 ] = quaternion;
        }

        if ( !reverse_option_is_enabled )
        {
            product_quaternion = quaternion_array[ 0 ];

            for ( quaternion_index = 1;
                  quaternion_index < quaternion_array.length;
                  ++quaternion_index )
            {
                first_quaternion = product_quaternion;
                second_quaternion = quaternion_array[ quaternion_index ];

                product_quaternion.SetProductQuaternion( first_quaternion, second_quaternion );
            }
        }
        else
        {
            product_quaternion = quaternion_array[ quaternion_array.length - 1 ];

            for ( quaternion_index = quaternion_array.length - 2;
                  quaternion_index >= 0;
                  --quaternion_index )
            {
                first_quaternion = quaternion_array[ quaternion_index ];
                second_quaternion = product_quaternion;

                product_quaternion.SetProductQuaternion( first_quaternion, second_quaternion );
            }
        }

        product_quaternion.Print( quaternion_name );
    }
    else
    {
        writeln( "Usage : quage [options] first_quaternion second_quaternion ..." );
        writeln( "Options :" );
        writeln( "    --reverse" );
        
        writeln( "Invalid arguments : " ~ argument_array.to!string() );
    }
}

























