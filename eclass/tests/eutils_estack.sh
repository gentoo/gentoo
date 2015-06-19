#!/bin/bash
# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/tests/eutils_estack.sh,v 1.2 2015/05/10 16:38:08 ulm Exp $

source tests-common.sh

inherit eutils

tbegin "initial stack state"
estack_pop teststack
# Should be empty and thus return 1
[[ $? -eq 1 ]]
tend $?

tbegin "simple push/pop"
estack_push ttt 1
pu=$?
estack_pop ttt
po=$?
[[ ${pu}${po} == "00" ]]
tend $?

tbegin "simple push/pop var"
estack_push xxx "boo ga boo"
pu=$?
estack_pop xxx i
po=$?
[[ ${pu}${po} == "00" ]] && [[ ${i} == "boo ga boo" ]]
tend $?

tbegin "multi push/pop"
estack_push yyy {1..10}
pu=$?
i=0
while estack_pop yyy ; do
	: $(( i++ ))
done
[[ ${pu} -eq 0 && ${i} -eq 10 ]]
tend $?

tbegin "umask push/pop"
u0=$(umask)
eumask_push 0000
pu=$?
u1=$(umask)
eumask_pop
po=$?
u2=$(umask)
[[ ${pu}${po}:${u0}:${u1}:${u2} == "00:${u0}:0000:${u0}" ]]
tend $?

texit
