#!/bin/bash
# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

source tests-common.sh || exit

inherit eapi9-pipestatus

tps() {
	local exp_ret=${1} cmd=${2}
	local have_ret
	tbegin "${cmd} -> ret: ${exp_ret}"
	eval "${cmd}; pipestatus"
	have_ret=$?
	[[ ${have_ret} -eq ${exp_ret} ]]
	tend $? "returned: ${have_ret}"
}

tpsv() {
	local exp_ret=${1} exp_out=${2} cmd=${3}
	local have_ret have_out
	tbegin "${cmd} -> ret: ${exp_ret}, out: ${exp_out}"
	have_out=$(eval "${cmd}; pipestatus -v")
	have_ret=$?
	[[ ${have_ret} -eq ${exp_ret} && ${have_out} == "${exp_out}" ]]
	tend $? "returned: ${have_ret}, output: ${have_out}"
}

txf() {
	local out
	tbegin "XFAIL: $*"
	out=$("$@" 2>&1)
	[[ ${out} == die:* ]]
	tend $? "function did not die"
}

ret() {
	return ${1}
}

tps 0           "true"
tps 1           "false"
tps 0           "true | true"
tps 1           "false | true"
tps 2           "ret 2 | true"
tps 1           "true | false | true"
tps 5           "true | false | ret 5 | true"
tpsv 0 "0 0 0"  "true | true | true"
tpsv 1 "1 0"    "false | true"
tpsv 2 "3 2 0"  "ret 3 | ret 2 | true"

txf pipestatus bad_arg
txf pipestatus -v extra_arg

texit
