# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ANT_TASK_JDKVER=1.8
ANT_TASK_JREVER=1.8
ANT_TASK_DEPNAME="xz-java"

inherit ant-tasks

DESCRIPTION="Apache Ant's optional tasks for XZ compression"

KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

DEPEND="dev-java/xz-java"
RDEPEND="${DEPEND}"
