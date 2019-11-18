#!/bin/bash

source {{ python_virtualenv_path }}/bin/activate
cd {{ nkr_proxy_web_app_src_path }}
python -m nkr_proxy.cron.check_session_expire
