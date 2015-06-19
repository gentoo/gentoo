# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ant-apache-xalan2/ant-apache-xalan2-1.8.4.ebuild,v 1.5 2012/12/05 17:29:24 ago Exp $

EAPI="4"

ANT_TASK_DEPNAME="xalan"

inherit ant-tasks

KEYWORDS="amd64 ~ia64 ppc ppc64 x86 ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND="dev-java/xalan"
RDEPEND="${DEPEND}"

src_unpack() {
	ant-tasks_src_unpack all
}
