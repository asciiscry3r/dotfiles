#!/usr/bin/env bash

clipboard=`xclip`
send-notify `trans :ru $clipboard`

