# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

inherit java-pkg-opt-2 autotools-utils

DESCRIPTION="General purpose computer algebra system"
HOMEPAGE="http://yacas.sourceforge.net/"
SRC_URI="http://${PN}.sourceforge.net/backups/${P}.tar.gz"

SLOT="0/1"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc java static-libs server"

DEPEND="java? ( >=virtual/jdk-1.6 )"
RDEPEND="java? ( >=virtual/jre-1.6 )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.3.4-java-version.patch
)

src_configure() {
	local myeconfargs=(
		--with-html-dir="/usr/share/doc/${PF}/html"
		$(use_enable doc html-doc)
		$(use_enable server)
	)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile -j1
	if use java; then
		cd "${BUILD_DIR}"/JavaYacas || die
		# -j1 because of file generation dependence
		emake -j1 -f makefile.yacas
	fi
}

src_install() {
	autotools-utils_src_install
	if use java; then
		cd "${BUILD_DIR}"/JavaYacas || die
		java-pkg_dojar yacas.jar
		java-pkg_dolauncher jyacas --main net.sf.yacas.YacasConsole
		insinto /usr/share/${PN}
		doins "${S}"/JavaYacas/{hints.txt,yacasconsole.html}
	fi
}
