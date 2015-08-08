#!/bin/bash
# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

source tests-common.sh

inherit eutils

tbegin "simple push/pop"
VAR=1
evar_push VAR
pu=$?
VAR=2
evar_pop
po=$?
[[ ${pu}${po}${VAR} == "001" ]]
tend $?

tbegin "unset push/pop"
unset VAR
evar_push VAR
pu=$?
VAR=2
evar_pop
po=$?
[[ ${pu}${po}${VAR+set} == "00" ]]
tend $?

tbegin "empty push/pop"
VAR=
evar_push VAR
pu=$?
VAR=2
evar_pop
po=$?
[[ ${pu}${po}${VAR+set}${VAR} == "00set" ]]
tend $?

tbegin "export push/pop"
export VAR=exported
evar_push VAR
pu=$?
VAR=2
evar_pop
po=$?
var=$(bash -c 'echo ${VAR}')
[[ ${pu}${po}${var} == "00exported" ]]
tend $?

tbegin "unexport push/pop"
unset VAR
VAR=not-exported
evar_push VAR
pu=$?
VAR=2
evar_pop
po=$?
var=$(bash -c 'echo ${VAR+set}')
[[ ${pu}${po}${VAR}${var} == "00not-exported" ]]
tend $?

tbegin "multi push/pop"
A=a B=b C=c
evar_push A B C
pu=$?
A=A B=B C=C
evar_pop 1
po1=$?
[[ ${A}${B}${C} == "ABc" ]]
po2=$?
evar_pop 2
po3=$?
var=$(bash -c 'echo ${VAR+set}')
[[ ${pu}${po1}${po2}${po3}${A}${B}${C} == "0000abc" ]]
tend $?

tbegin "simple push_set/pop"
VAR=1
evar_push_set VAR 2
pu=$?
[[ ${VAR} == "2" ]]
po1=$?
evar_pop
po2=$?
[[ ${pu}${po1}${po2}${VAR} == "0001" ]]
tend $?

tbegin "unset push_set/pop"
VAR=1
evar_push_set VAR
pu=$?
[[ ${VAR+set} != "set" ]]
po1=$?
evar_pop
po2=$?
[[ ${pu}${po1}${po2}${VAR} == "0001" ]]
tend $?

texit
