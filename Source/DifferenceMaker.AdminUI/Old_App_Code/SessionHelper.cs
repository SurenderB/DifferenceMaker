using System;
using System.Collections.Generic;

/// <summary>
/// Implements methods that help retrieve ASP.NET session variables
/// </summary>
public static class SessionHelper
{
    /// <summary>
    /// Static constructor
    /// </summary>
	static SessionHelper()
	{
	}

    /// <summary>
    /// Gets a non-null session variable.
    /// </summary>
    /// <typeparam name="T">The type to cast the value to.</typeparam>
    /// <param name="sessionVal">The value of the session variable to cast.</param>
    /// <returns>A non-null session varial cast to the specified type.</returns>
    static public T GetValue<T>(object sessionVal)
    {
        if (sessionVal == null)
            return default(T);
        else
            return (T)sessionVal;
    }

    public static T Try<T>(this object value, T valueIfNull)
    {
        if (value == null)
            return valueIfNull;
        else
            return (T)Convert.ChangeType(value, typeof(T));
    }

    public static void AddList<T>(this List<List<T>> list, params T[] items)
    {
        var itemList = new List<T>();
        foreach (var item in items)
            itemList.Add(item);

        list.Add(itemList);
    }

    public static void AddList<T>(this List<List<T>> list, params object[] items)
    {
        var itemList = new List<T>();
        foreach (var item in items)
            itemList.Add((T)Convert.ChangeType(item, typeof(T)));

        list.Add(itemList);
    }
}
