#!/usr/bin/python
# encoding: utf-8

import sys
from workflow import Workflow, web

def search(query):
    url = 'http://localhost:48065/wechat/search'
    parameters = dict(keyword=query)
    response = web.get(url, parameters)
    response.raise_for_status()
    return response.json()

def main(wf):
    try:
        query = wf.args[0]
        contacts = search(query)
        if len(contacts) == 0:
            wf.add_item(title='Empty results', subtitle='Please try another keyword', valid=False)
        else:
            for contact in contacts:
                avatar = contact.get('wt_avatarPath')
                remark = contact.get('m_nsRemark')
                nickname = contact.get('m_nsNickName')
                username = contact.get('m_nsUsrName')
                wf.add_item(title=remark or nickname, subtitle=nickname, icon=avatar, arg=username, valid=True)
    except:
        wf.add_item(title='Failed to connect to the WeChat.', subtitle='Please open your WeChat.app and retry.', valid=False)
    wf.send_feedback()

if __name__ == '__main__':
    wf = Workflow()
    logger = wf.logger
    sys.exit(wf.run(main))
