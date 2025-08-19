#!/usr/bin/python
# encoding: utf-8

import sys
from workflow import Workflow, web

def start(query):
    url = 'http://localhost:48065/wechat/start'
    parameters = dict(session=query)
    response = web.get(url, parameters)
    response.raise_for_status()
    return response

def main(wf):
    query = wf.args[0]
    start(query)
    wf.send_feedback()

if __name__ == '__main__':
    wf = Workflow()
    logger = wf.logger
    sys.exit(wf.run(main))
