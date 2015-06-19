# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ant-junit/ant-junit-1.8.2.ebuild,v 1.6 2012/05/25 11:21:46 ago Exp $

EAPI="4"

inherit ant-tasks

KEYWORDS="amd64 ~ia64 ~ppc ~ppc64 x86 ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND="dev-java/junit:0"
RDEPEND="${DEPEND}"

src_compile() {
	eant jar-junit
}
