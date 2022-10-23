#!/usr/bin/env bash
# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
source tests-common.sh || exit

inherit systemd

test_system_dir() {
	local exp1="${EPREFIX}$1"
	local exp2="${EPREFIX}/usr$1"
	shift
	tbegin "$@"
	local act=$("$@")
	[[ ${act} == ${exp1} || ${act} == ${exp2} ]]
	tend $?
}

test_user_dir() {
	local exp="${EPREFIX}$1"
	shift
	tbegin "$@"
	local act=$("$@")
	[[ ${act} == ${exp} ]]
	tend $?
}

test_systemd_unprefix() {
	local exp=$1
	local EPREFIX=$2
	shift 2
	tbegin "EPREFIX=${EPREFIX} _systemd_unprefix $@"
	[[ "$(_systemd_unprefix "$@")" == "${exp}" ]]
	tend $?
}

test_system_dir /lib/systemd/system systemd_get_systemunitdir
test_system_dir /lib/systemd systemd_get_utildir
test_system_dir /lib/systemd/system-generators systemd_get_systemgeneratordir
test_system_dir /lib/systemd/system-preset systemd_get_systempresetdir
test_system_dir /lib/systemd/system-sleep systemd_get_sleepdir

test_user_dir /usr/lib/systemd/user systemd_get_userunitdir

test_systemd_unprefix /lib/systemd /prefix echo /prefix/lib/systemd
test_systemd_unprefix /lib/systemd '' echo /lib/systemd
test_systemd_unprefix /lib/systemd '/*' echo '/*/lib/systemd'

texit
