# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ant-apache-bsf/ant-apache-bsf-1.8.2.ebuild,v 1.3 2012/05/25 11:24:37 ago Exp $

EAPI="4"

ANT_TASK_DEPNAME="bsf-2.3"

inherit ant-tasks

KEYWORDS="amd64 ~ppc ~ppc64 x86 ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND=">=dev-java/bsf-2.4.0-r1:2.3[python?,javascript?,tcl?]"
RDEPEND="${DEPEND}"

IUSE="python javascript tcl"

JAVA_PKG_FILTER_COMPILER="jikes"

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog "Also, >=dev-java/bsf-2.4.0-r1 adds optional support for groovy,"
		elog "ruby and beanshell. See its postinst elog messages for instructions."
	fi
}
