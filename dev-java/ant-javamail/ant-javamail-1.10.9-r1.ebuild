# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ANT_TASK_JDKVER=1.8
ANT_TASK_JREVER=1.8
ANT_TASK_DEPNAME=( "gnu-jaf-1" "javax-mail" )

inherit ant-tasks

KEYWORDS="amd64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

# needs some classes from javax.activation.* which are not in jdk 11
DEPEND="virtual/jdk:1.8
	dev-java/gnu-jaf:1
	dev-java/javax-mail:0"
RDEPEND="${DEPEND}"
