# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ant-javamail/ant-javamail-1.9.1.ebuild,v 1.1 2013/07/05 14:13:11 tomwij Exp $

EAPI="5"

ANT_TASK_DEPNAME="--virtual javamail"

inherit ant-tasks

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd ~x64-freebsd ~x86-freebsd \
	~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris \
	~sparc64-solaris ~x64-solaris ~x86-solaris"

DEPEND="java-virtuals/javamail
	java-virtuals/jaf"
RDEPEND="${DEPEND}"

src_unpack() {
	ant-tasks_src_unpack all
	java-pkg_jar-from --virtual jaf
}
