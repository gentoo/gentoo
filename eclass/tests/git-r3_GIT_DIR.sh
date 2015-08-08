#!/bin/bash
# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

source tests-common.sh

inherit git-r3

testdir=${pkg_root}/git
mkdir "${testdir}" || die "unable to mkdir testdir"
cd "${testdir}" || die "unable to cd to testdir"

EGIT3_STORE_DIR=store
mkdir "${EGIT3_STORE_DIR}" || die "unable to mkdir store"

# Test cleaning up canonical repo URI
test_repouri() {
	local uri=${1}
	local expect=${2}
	local -x GIT_DIR

	tbegin "GIT_DIR for ${uri}"

	_git-r3_set_gitdir "${uri}" &>/dev/null
	local got=${GIT_DIR#${EGIT3_STORE_DIR}/}

	[[ ${expect} == ${got} ]]
	tend ${?} || eerror "Expected: ${expect}, got: ${got}"
}

test_repouri git://git.overlays.gentoo.org/proj/portage.git proj_portage.git
test_repouri https://git.overlays.gentoo.org/gitroot/proj/portage.git proj_portage.git
test_repouri git+ssh://git@git.overlays.gentoo.org/proj/portage.git proj_portage.git

test_repouri git://anongit.freedesktop.org/mesa/mesa mesa_mesa.git
test_repouri ssh://git.freedesktop.org/git/mesa/mesa mesa_mesa.git
test_repouri http://anongit.freedesktop.org/git/mesa/mesa.git mesa_mesa.git
test_repouri http://cgit.freedesktop.org/mesa/mesa/ mesa_mesa.git

test_repouri https://code.google.com/p/snakeoil/ snakeoil.git

test_repouri git://git.code.sf.net/p/xournal/code xournal_code.git
test_repouri http://git.code.sf.net/p/xournal/code xournal_code.git

test_repouri git://git.gnome.org/glibmm glibmm.git
test_repouri https://git.gnome.org/browse/glibmm glibmm.git
test_repouri ssh://USERNAME@git.gnome.org/git/glibmm glibmm.git

test_repouri git://git.kernel.org/pub/scm/git/git.git git_git.git
test_repouri http://git.kernel.org/pub/scm/git/git.git git_git.git
test_repouri https://git.kernel.org/pub/scm/git/git.git git_git.git
test_repouri https://git.kernel.org/cgit/git/git.git/ git_git.git

#test_repouri git@github.com:gentoo/identity.gentoo.org.git gentoo_identity.gentoo.org.git
test_repouri https://github.com/gentoo/identity.gentoo.org.git gentoo_identity.gentoo.org.git

#test_repouri git@bitbucket.org:mgorny/python-exec.git mgorny_python-exec.git
test_repouri https://mgorny@bitbucket.org/mgorny/python-exec.git mgorny_python-exec.git

texit
