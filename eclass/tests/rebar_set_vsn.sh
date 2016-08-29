#!/bin/bash
# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

source tests-common.sh

EAPI=6

inherit rebar

EPREFIX="${tmpdir}/fakeroot"
S="${WORKDIR}/${P}"

setup() {
	mkdir -p "${S}/src" || die

	cat <<EOF >"${S}/app.src.expected" || die
%%% Comment

{application, esip,
 [{description, "ProcessOne SIP server component in Erlang"},
  {vsn, "0"},
  {modules, []},
  {registered, []},
EOF

	cat <<EOF >"${S}/app.src" || die
%%% Comment

{application, esip,
 [{description, "ProcessOne SIP server component in Erlang"},
  {vsn, git},
  {modules, []},
  {registered, []},
EOF
}

test_typical_app_src() {
	local diff_rc
	local unit_rc

	# Prepare
	cd "${S}" || die
	cp app.src "src/${PN}.app.src" || die

	# Run unit
	(rebar_set_vsn)
	unit_rc=$?

	# Test result
	diff "src/${PN}.app.src" app.src.expected
	diff_rc=$?

	[[ ${unit_rc}${diff_rc} = 00 ]]
}

test_app_src_missing() {
	local unit_rc

	# Prepare
	cd "${S}" || die
	rm -f "src/${PN}.app.src" || die

	# Run unit
	(rebar_set_vsn 2>/dev/null)
	unit_rc=$?

	[[ ${unit_rc} = 1 ]]
}

test_set_custom_version() {
	local diff_rc
	local unit_rc

	# Prepare
	cd "${S}" || die
	cp app.src "src/${PN}.app.src" || die
	cat <<EOF >"${S}/custom_app.src.expected" || die
%%% Comment

{application, esip,
 [{description, "ProcessOne SIP server component in Erlang"},
  {vsn, "1.2.3"},
  {modules, []},
  {registered, []},
EOF

	# Run unit
	(rebar_set_vsn 1.2.3)
	unit_rc=$?

	# Test result
	diff "src/${PN}.app.src" custom_app.src.expected
	diff_rc=$?

	[[ ${unit_rc}${diff_rc} = 00 ]]
}


setup

tbegin "rebar_set_vsn deals with typical app.src"
test_typical_app_src
tend $?

tbegin "rebar_set_vsn fails when app.src is missing"
test_app_src_missing
tend $?

tbegin "rebar_set_vsn sets custom version in app.src"
test_set_custom_version
tend $?

texit
