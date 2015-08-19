# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source examples"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Yet Another NFS - a Java NFS library"
HOMEPAGE="https://java.net/projects/yanfs"
SRC_URI="http://dev.gentoo.org/~ercpe/distfiles/dev-java/yanfs/yanfs-1.0.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=virtual/jre-1.6"
DEPEND=">=virtual/jdk-1.6"

S="${WORKDIR}/${P}"

java_prepare() {
	epatch "${FILESDIR}/${PV}-make.patch"
	rm -r "${S}"/src/com/sun/gssapi/mechs/dummy || die

	mkdir examples && \
		mv "${S}"/src/com/sun/rpc/samples/ examples/rpc && \
		mv "${S}"/src/com/sun/gssapi/samples/ examples/gssapi || die
}

src_compile() {
	CODEMGR_WS="${S}" emake -C "${S}/src/com/sun/gssapi/"

	java-pkg-2_src_compile
}

src_install() {
	java-pkg_dojar "${S}/${PN}.jar"

	use source && java-pkg_dosrc "${S}"/src/*
	use doc && java-pkg_dojavadoc "${S}"/api/
	use examples && java-pkg_doexamples examples/*
}
