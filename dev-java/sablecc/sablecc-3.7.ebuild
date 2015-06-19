# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/sablecc/sablecc-3.7.ebuild,v 1.2 2013/05/09 13:23:22 tomwij Exp $

EAPI="5"

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java based compiler / parser generator"
HOMEPAGE="http://www.sablecc.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5"

java_prepare() {
	rm -v "${S}"/lib/*.jar || die
}

src_install() {
	java-pkg_dojar lib/*

	dobin "${FILESDIR}"/${PN}

	dodoc AUTHORS THANKS
	dohtml README.html

	use source && java-pkg_dosrc src/*
}
