#!/bin/bash
# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

source tests-common.sh

EAPI=6

inherit rebar

EPREFIX="${tmpdir}/fakeroot"
S="${WORKDIR}/${P}"

setup() {
	mkdir -p "${S}" || die

	cat <<EOF >"${S}/rebar.config.expected" || die
%%% Comment

{port_specs, [{"priv/lib/esip_drv.so", ["c_src/esip_codec.c"]}]}.

{deps, []}.

{clean_files, ["c_src/esip_codec.gcda", "c_src/esip_codec.gcno"]}.
EOF

	cat <<EOF >"${S}/typical.config" || die
%%% Comment

{port_specs, [{"priv/lib/esip_drv.so", ["c_src/esip_codec.c"]}]}.

{deps, [{stun, ".*", {git, "https://github.com/processone/stun", {tag, "1.0.3"}}},
	{fast_tls, ".*", {git, "https://github.com/processone/fast_tls", {tag, "1.0.3"}}},
	{p1_utils, ".*", {git, "https://github.com/processone/p1_utils", {tag, "1.0.3"}}}]}.

{clean_files, ["c_src/esip_codec.gcda", "c_src/esip_codec.gcno"]}.
EOF

	cat <<EOF >"${S}/deps_one_line.config" || die
%%% Comment

{port_specs, [{"priv/lib/esip_drv.so", ["c_src/esip_codec.c"]}]}.

{deps, [{stun, ".*", {git, "https://github.com/processone/stun", {tag, "1.0.3"}}}, {fast_tls, ".*", {git, "https://github.com/processone/fast_tls", {tag, "1.0.3"}}}, {p1_utils, ".*", {git, "https://github.com/processone/p1_utils", {tag, "1.0.3"}}}]}.

{clean_files, ["c_src/esip_codec.gcda", "c_src/esip_codec.gcno"]}.
EOF
}

test_typical_config() {
	local diff_rc
	local unit_rc

	# Prepare
	cd "${S}" || die
	cp typical.config rebar.config || die

	# Run unit
	(rebar_remove_deps)
	unit_rc=$?

	# Test result
	diff rebar.config rebar.config.expected
	diff_rc=$?

	[[ ${unit_rc}${diff_rc} = 00 ]]
}

test_typical_config_with_different_name() {
	local diff_rc
	local unit_rc

	# Prepare
	cd "${S}" || die
	cp typical.config other.config || die

	# Run unit
	(rebar_remove_deps other.config)
	unit_rc=$?

	# Test result
	diff other.config rebar.config.expected
	diff_rc=$?

	[[ ${unit_rc}${diff_rc} = 00 ]]
}

test_deps_in_one_line() {
	local diff_rc
	local unit_rc

	# Prepare
	cd "${S}" || die
	cp deps_one_line.config rebar.config || die

	# Run unit
	(rebar_remove_deps)
	unit_rc=$?

	# Test result
	diff rebar.config rebar.config.expected
	diff_rc=$?

	[[ ${unit_rc}${diff_rc} = 00 ]]
}

setup

tbegin "rebar_remove_deps deals with typical config"
test_typical_config
tend $?

tbegin "rebar_remove_deps deals with typical config with different name"
test_typical_config_with_different_name
tend $?

tbegin "rebar_remove_deps deals with all deps in one line"
test_deps_in_one_line
tend $?

texit
