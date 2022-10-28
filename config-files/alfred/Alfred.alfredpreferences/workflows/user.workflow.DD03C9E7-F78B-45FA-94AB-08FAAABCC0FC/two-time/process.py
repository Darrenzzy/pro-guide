# -*- coding: utf-8 -*-

import alfred
import calendar
import datetime, time
from delorean import utcnow, parse, epoch

def process(query_str):
    """ Entry point """
    value = parse_query_value(query_str)
    if value is not None:
        results = alfred_items_for_value(value)
        xml = alfred.xml(results) # compiles the XML answer
        alfred.write(xml) # writes the XML back to Alfred

def parse_query_value(query_str):
    """ Return value for the query string """
    try:
        query_str = str(query_str).strip('"\' ')
        if query_str == "" or query_str == 'now':
            d = utcnow()
        else:
            # Parse datetime string or timestamp
            try:
                if len(query_str) == 13:
                    d = epoch(float(query_str)/1000) # if query string is in ms
                else:
                    d = epoch(float(query_str))
            except ValueError:
                d = parse(str(query_str))
    except (TypeError, ValueError):
        d = None
    return d

def alfred_items_for_value(value):
    """
    Given a delorean datetime object, return a list of
    alfred items for each of the results
    """

    index = 0
    timestring_format = "%a, %Y-%m-%d %H:%M:%S"
    dt_object = value.datetime
    results = []

    # First item as timestamp
    item_value = calendar.timegm(dt_object.utctimetuple())
    results.append(alfred.Item(
        title=str(item_value),
        subtitle=u'Epoch Timestamp (sec)',
        attributes={
            'uid': alfred.uid(index),
            'arg': item_value,
        },
        icon='icon.png',
    ))
    index += 1

    # Second item as GMT timestamp
    item_value = dt_object.strftime(timestring_format)
    results.append(alfred.Item(
        title=str(item_value),
        subtitle='GMT timestamp',
        attributes={
            'uid': alfred.uid(index),
            'arg': item_value,
        },
    icon='icon.png',
    ))
    index += 1

    # Third item as local timestamp (most likely PST)
    now = int(time.time())
    offset = datetime.datetime.fromtimestamp(now) - datetime.datetime.utcfromtimestamp(now)
    item_value = datetime.datetime.utcfromtimestamp(calendar.timegm(dt_object.utctimetuple())) + offset
    results.append(alfred.Item(
        title=item_value.strftime(timestring_format),
        subtitle=u'{} timestamp'.format(time.tzname[0]),
        attributes={
            'uid': alfred.uid(index),
            'arg': item_value,
        },
        icon='icon.png',
    ))
    index += 1

    return results

if __name__ == "__main__":
    try:
        query_str = alfred.args()[0]
    except IndexError:
        query_str = None
    process(query_str)
