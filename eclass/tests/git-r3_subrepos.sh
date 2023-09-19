#!/bin/bash
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

source tests-common.sh || exit

inherit git-r3

# Test getting submodule URIs
test_subrepos() {
	local suburi=${1}
	local expect=( "${@:2}" )

	tbegin "subrepos for ${suburi} -> ${expect[0]}${expect[1]+...}"

	local subrepos
	_git-r3_set_subrepos "${suburi}" "${repos[@]}"

	[[ ${expect[@]} == ${subrepos[@]} ]]
	tend ${?} || eerror "Expected: ${expect[@]}, got: ${subrepos[@]}"
}

# parent repos
repos=( http://foohub/fooman/foo.git git://foohub/fooman/foo.git )

# absolute URI
test_subrepos http://foo/bar http://foo/bar
test_subrepos /foo/bar /foo/bar

# plain relative URI
test_subrepos ./baz http://foohub/fooman/foo.git/baz git://foohub/fooman/foo.git/baz

# backward relative URIs
test_subrepos ../baz.git http://foohub/fooman/baz.git git://foohub/fooman/baz.git
test_subrepos ../../bazman/baz.git http://foohub/bazman/baz.git git://foohub/bazman/baz.git

texit
