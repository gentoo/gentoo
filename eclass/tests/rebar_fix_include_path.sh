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

	for pkg in foo-0.1.0 bar-0.1.0; do
		mkdir -p "${EPREFIX}$(get_erl_libs)/${pkg}/include" || die
	done

	cat <<EOF >"${S}/typical.config" || die
%%% Comment

{erl_opts, [debug_info, {src_dirs, ["src"]},
			{i, "include"},
			{i, "deps/foo/include"},
			{i, "../foo/include"}]}.

{port_env, [{"CFLAGS", "\$CFLAGS"}, {"LDFLAGS", "\$LDFLAGS"}]}.
EOF

	cat <<EOF >"${S}/typical.config.expected" || die
%%% Comment

{erl_opts, [debug_info, {src_dirs, ["src"]},
			{i, "include"},
			{i, "${EPREFIX}$(get_erl_libs)/foo-0.1.0/include"},
			{i, "../foo/include"}]}.

{port_env, [{"CFLAGS", "\$CFLAGS"}, {"LDFLAGS", "\$LDFLAGS"}]}.
EOF

	cat <<EOF >"${S}/inc_one_line.config" || die
%%% Comment

{erl_opts, [debug_info, {src_dirs, ["src"]}, {i, "include"}, {i, "deps/foo/include"}, {i, "../foo/include"}]}.

{port_env, [{"CFLAGS", "\$CFLAGS"}, {"LDFLAGS", "\$LDFLAGS"}]}.
EOF

	cat <<EOF >"${S}/inc_one_line.config.expected" || die
%%% Comment

{erl_opts, [debug_info, {src_dirs, ["src"]}, {i, "include"}, {i, "${EPREFIX}$(get_erl_libs)/foo-0.1.0/include"}, {i, "../foo/include"}]}.

{port_env, [{"CFLAGS", "\$CFLAGS"}, {"LDFLAGS", "\$LDFLAGS"}]}.
EOF
}

test_typical_config() {
	local diff_rc
	local unit_rc

	# Prepare
	cd "${S}" || die
	cp typical.config rebar.config || die

	# Run unit
	(rebar_fix_include_path foo)
	unit_rc=$?

	# Test result
	diff rebar.config typical.config.expected
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
	(rebar_fix_include_path foo other.config)
	unit_rc=$?

	# Test result
	diff other.config typical.config.expected
	diff_rc=$?

	[[ ${unit_rc}${diff_rc} = 00 ]]
}

test_multiple_versions() {
	local diff_rc
	local unit_rc

	# Prepare
	cd "${S}" || die
	cp typical.config rebar.config || die
	mkdir -p "${EPREFIX}$(get_erl_libs)/foo-1.0.0/include" || die

	# Run unit
	(rebar_fix_include_path foo 2>/dev/null)
	unit_rc=$?

	# Test result
	diff rebar.config typical.config
	diff_rc=$?

	# Clean up
	rm -r "${EPREFIX}$(get_erl_libs)/foo-1.0.0" || die

	[[ ${unit_rc}${diff_rc} = 10 ]]
}

test_not_found() {
	local diff_rc
	local unit_rc

	# Prepare
	cd "${S}" || die
	cp typical.config rebar.config || die

	# Run unit
	(rebar_fix_include_path fo 2>/dev/null)
	unit_rc=$?

	# Test result
	diff rebar.config typical.config
	diff_rc=$?

	[[ ${unit_rc}${diff_rc} = 10 ]]
}

test_includes_in_one_line() {
	local diff_rc
	local unit_rc

	# Prepare
	cd "${S}" || die
	cp inc_one_line.config rebar.config || die

	# Run unit
	(rebar_fix_include_path foo)
	unit_rc=$?

	# Test result
	diff rebar.config inc_one_line.config.expected
	diff_rc=$?

	[[ ${unit_rc}${diff_rc} = 00 ]]
}

setup

tbegin "rebar_fix_include_path deals with typical config"
test_typical_config
tend $?

tbegin "rebar_fix_include_path deals with typical config with different name"
test_typical_config_with_different_name
tend $?

tbegin "rebar_fix_include_path fails on multiple versions of dependency"
test_multiple_versions
tend $?

tbegin "rebar_fix_include_path fails if dependency is not found"
test_not_found
tend $?

tbegin "rebar_fix_include_path deals with all includes in one line"
test_includes_in_one_line
tend $?

texit
