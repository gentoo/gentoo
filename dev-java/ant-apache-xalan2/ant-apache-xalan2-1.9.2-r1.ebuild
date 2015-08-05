# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ant-apache-xalan2/ant-apache-xalan2-1.9.2-r1.ebuild,v 1.1 2015/08/04 23:14:05 chewi Exp $

EAPI="5"

ANT_TASK_DEPNAME="xalan"

inherit ant-tasks

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

DEPEND="dev-java/xalan:0
	dev-java/xalan-serializer:0"

RDEPEND="${DEPEND}"

src_unpack() {
	ant-tasks_src_unpack all
	java-pkg_jar-from xalan-serializer
}
