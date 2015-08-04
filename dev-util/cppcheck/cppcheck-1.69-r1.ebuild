# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cppcheck/cppcheck-1.69-r1.ebuild,v 1.2 2015/08/04 16:59:08 pinkbyte Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1 eutils flag-o-matic qt4-r2 toolchain-funcs

DESCRIPTION="static analyzer of C/C++ code"
HOMEPAGE="http://cppcheck.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="htmlreport pcre qt4"

RDEPEND="htmlreport? ( dev-python/pygments[${PYTHON_USEDEP}] )
	>=dev-libs/tinyxml2-2
	qt4? ( dev-qt/qtgui:4 )
	pcre? ( dev-libs/libpcre )"
DEPEND="${RDEPEND}
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	virtual/pkgconfig"

src_prepare() {
	# Drop bundled libs, patch Makefile generator and re-run it
	rm -r externals || die
	epatch "${FILESDIR}"/${PN}-1.69-tinyxml2.patch
	tc-export CXX
	emake dmake
	./dmake || die

	epatch "${FILESDIR}"/${PN}-1.69-c++0x.patch

	epatch_user
}

src_configure() {
	if use pcre ; then
		sed -e '/HAVE_RULES=/s:=no:=yes:' \
			-i Makefile
	fi
	if use qt4 ; then
		pushd gui
		qt4-r2_src_configure
		popd
	fi
}

src_compile() {
	export LIBS="$(pkg-config --libs tinyxml2)"
	emake ${PN} man \
		CFGDIR="${EROOT}usr/share/${PN}/cfg" \
		DB2MAN="${EROOT}usr/share/sgml/docbook/xsl-stylesheets/manpages/docbook.xsl"

	if use qt4 ; then
		pushd gui
		qt4-r2_src_compile
		popd
	fi
	if use htmlreport ; then
		pushd htmlreport
		distutils-r1_src_compile
		popd
	fi
}

src_test() {
	# safe final version
	mv -v ${PN}{,.final}
	mv -v lib/library.o{,.final}
	mv -v cli/cppcheckexecutor.o{,.final}
	#trigger recompile with CFGDIR inside ${S}
	emake check CFGDIR="${S}/cfg"
	# restore
	mv -v ${PN}{.final,}
	mv -v lib/library.o{.final,}
	mv -v cli/cppcheckexecutor.o{.final,}
}

src_install() {
	# it's not autotools-based, so "${ED}" here, not "${D}", bug 531760
	emake install DESTDIR="${ED}"

	insinto "/usr/share/${PN}/cfg"
	doins cfg/*.cfg
	if use qt4 ; then
		dobin gui/${PN}-gui
		dodoc readme_gui.txt gui/{projectfile.txt,gui.${PN}}
	fi
	if use htmlreport ; then
		pushd htmlreport
		distutils-r1_src_install
		popd
		find "${D}" -name "*.egg-info" -delete
	else
		rm "${ED}/usr/bin/cppcheck-htmlreport" || die
	fi
	doman ${PN}.1
	dodoc readme.txt
	dodoc -r triage
}
