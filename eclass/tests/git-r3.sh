#!/bin/bash
# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/tests/git-r3.sh,v 1.6 2015/05/11 17:35:52 ulm Exp $

source tests-common.sh

inherit git-r3

testdir=${pkg_root}/git
mkdir "${testdir}" || die "unable to mkdir testdir"
cd "${testdir}" || die "unable to cd to testdir"

EGIT3_STORE_DIR=store
mkdir "${EGIT3_STORE_DIR}" || die "unable to mkdir store"

test_file() {
	local fn=${1}
	local expect=${2}

	if [[ ! -f ${fn} ]]; then
		eerror "${fn} does not exist (not checked out?)"
	else
		local got=$(<"${fn}")

		if [[ ${got} != ${expect} ]]; then
			eerror "${fn}, expected: ${expect}, got: ${got}"
		else
			return 0
		fi
	fi
	return 1
}

test_no_file() {
	local fn=${1}

	if [[ -f ${fn} ]]; then
		eerror "${fn} exists (wtf?!)"
	else
		return 0
	fi
	return 1
}

test_repo_clean() {
	local P=${P}_${FUNCNAME#test_}

	(
		mkdir repo
		cd repo
		git init -q
		echo test > file
		git add file
		git commit -m 1 -q
		echo other-text > file2
		git add file2
		git commit -m 2 -q
	) || die "unable to prepare repo"

	# we need to use an array to preserve whitespace
	local EGIT_REPO_URI=(
		"ext::git daemon --export-all --base-path=. --inetd %G/repo"
	)

	tbegin "fetching from a simple repo"
	(
		git-r3_src_unpack
		test_file "${WORKDIR}/${P}/file" test && \
		test_file "${WORKDIR}/${P}/file2" other-text
	) &>fetch.log

	eend ${?} || cat fetch.log
}

test_repo_revert() {
	local P=${P}_${FUNCNAME#test_}

	(
		cd repo
		git revert -n HEAD^
		git commit -m r1 -q
	) || die "unable to prepare repo"

	# we need to use an array to preserve whitespace
	local EGIT_REPO_URI=(
		"ext::git daemon --export-all --base-path=. --inetd %G/repo"
	)

	tbegin "fetching revert"
	(
		git-r3_src_unpack
		test_no_file "${WORKDIR}/${P}/file" && \
		test_file "${WORKDIR}/${P}/file2" other-text
	) &>fetch.log

	eend ${?} || cat fetch.log
}

test_repo_branch() {
	local P=${P}_${FUNCNAME#test_}

	(
		cd repo
		git branch -q other-branch HEAD^
		git checkout -q other-branch
		echo one-more > file3
		git add file3
		git commit -m 3 -q
		git checkout -q master
	) || die "unable to prepare repo"

	# we need to use an array to preserve whitespace
	local EGIT_REPO_URI=(
		"ext::git daemon --export-all --base-path=. --inetd %G/repo"
	)
	local EGIT_BRANCH=other-branch

	tbegin "switching branches"
	(
		git-r3_src_unpack
		test_file "${WORKDIR}/${P}/file" test && \
		test_file "${WORKDIR}/${P}/file2" other-text && \
		test_file "${WORKDIR}/${P}/file3" one-more
	) &>fetch.log

	eend ${?} || cat fetch.log
}

test_repo_merge() {
	local P=${P}_${FUNCNAME#test_}

	(
		cd repo
		git branch -q one-more-branch HEAD^
		git checkout -q one-more-branch
		echo foobarbaz > file3
		git add file3
		git commit -m 3b -q
		git checkout -q master
		git merge -m 4 -q one-more-branch
	) || die "unable to prepare repo"

	# we need to use an array to preserve whitespace
	local EGIT_REPO_URI=(
		"ext::git daemon --export-all --base-path=. --inetd %G/repo"
	)

	tbegin "fetching a merge commit"
	(
		git-r3_src_unpack
		test_no_file "${WORKDIR}/${P}/file" && \
		test_file "${WORKDIR}/${P}/file2" other-text && \
		test_file "${WORKDIR}/${P}/file3" foobarbaz
	) &>fetch.log

	eend ${?} || cat fetch.log
}

test_repo_revert_merge() {
	local P=${P}_${FUNCNAME#test_}

	(
		cd repo
		git branch -q to-be-reverted
		git checkout -q to-be-reverted
		echo trrm > file3
		git add file3
		git commit -m 5b -q
		git checkout -q master
		echo trrm > file2
		git add file2
		git commit -m 5 -q
		git merge -m 6 -q to-be-reverted
		echo trrm > file
		git add file
		git commit -m 7 -q
		git revert -m 1 -n HEAD^
		git commit -m 7r -q
	) || die "unable to prepare repo"

	# we need to use an array to preserve whitespace
	local EGIT_REPO_URI=(
		"ext::git daemon --export-all --base-path=. --inetd %G/repo"
	)

	tbegin "fetching a revert of a merge commit"
	(
		git-r3_src_unpack
		test_file "${WORKDIR}/${P}/file" trrm && \
		test_file "${WORKDIR}/${P}/file2" trrm && \
		test_file "${WORKDIR}/${P}/file3" foobarbaz
	) &>fetch.log

	eend ${?} || cat fetch.log
}

test_repo_clean
test_repo_revert
test_repo_branch
test_repo_merge
test_repo_revert_merge

texit
