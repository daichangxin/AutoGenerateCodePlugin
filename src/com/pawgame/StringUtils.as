package com.pawgame
{
public class StringUtils
{
    public static function stringfy(obj:Object):String
    {
        var result:String = '';
        for (var key:String in obj)
        {
            if (result)
            {
                result += '&';
            }
            result += key + '=' + obj[key];
        }

        return result;
    }
}
}
