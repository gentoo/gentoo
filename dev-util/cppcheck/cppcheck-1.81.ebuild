# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1 flag-o-matic qmake-utils toolchain-funcs

DESCRIPTION="static analyzer of C/C++ code"
HOMEPAGE="http://cppcheck.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~x86"
IUSE="htmlreport pcre qt5"

RDEPEND="
	>=dev-libs/tinyxml2-2
	htmlreport? ( dev-python/pygments[${PYTHON_USEDEP}] )
	pcre? ( dev-libs/libpcre )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtprintsupport:5
	)
"
DEPEND="${RDEPEND}
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	virtual/pkgconfig
"

PATCHES=( "${FILESDIR}"/${PN}-1.75-tinyxml2.patch )

src_prepare() {
	default
	append-cxxflags -std=c++0x

	# Drop bundled libs, patch Makefile generator and re-run it
	rm -r externals/tinyxml || die
	tc-export CXX
	emake dmake
	./dmake || die
}

src_configure() {
	if use pcre ; then
		sed -e '/HAVE_RULES=/s:=no:=yes:' \
			-i Makefile
	fi
}

src_compile() {
	export LIBS="$(pkg-config --libs tinyxml2)"
	emake ${PN} man \
		CFGDIR="${EROOT}usr/share/${PN}/cfg" \
		DB2MAN="${EROOT}usr/share/sgml/docbook/xsl-stylesheets/manpages/docbook.xsl"

	if use qt5 ; then
		pushd gui
		eqmake5
		emake
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
	if use qt5 ; then
		dobin gui/${PN}-gui
		dodoc gui/{projectfile.txt,gui.${PN}}
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
	dodoc -r triage
}
