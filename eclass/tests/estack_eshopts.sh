#!/bin/bash
# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

source tests-common.sh

inherit estack

test-it() {
	local s0 s1 s2

	tbegin "push/pop '$*'"
	s0=$(shopt -p)
	t eshopts_push $*
	s1=$(shopt -p)
	t eshopts_pop
	s2=$(shopt -p)
	[[ ${s0} == "${s2}" ]] && \
	[[ ${s1} == *"shopt $*"* ]]
	tend $?
}

# should handle bug #395025
for arg in nullglob dotglob extglob ; do
	for flag in s u ; do
		test-it -${flag} ${arg}
	done
done

tbegin "multi push/pop"
s0=$(shopt -p)
t eshopts_push -s dotglob
t eshopts_push -u dotglob
t eshopts_push -s extglob
t eshopts_push -u dotglob
t eshopts_push -s dotglob
t eshopts_pop
t eshopts_pop
t eshopts_pop
t eshopts_pop
t eshopts_pop
s1=$(shopt -p)
[[ ${s0} == "${s1}" ]]
tend $?

texit
