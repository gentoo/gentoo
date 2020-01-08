# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{2_7,3_6} )
inherit distutils-r1 qmake-utils toolchain-funcs

DESCRIPTION="Static analyzer of C/C++ code"
HOMEPAGE="https://github.com/danmar/cppcheck"
SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 hppa ~ppc64 sparc x86"
IUSE="htmlreport pcre qt5"

RDEPEND="
	dev-libs/tinyxml2:=
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
PATCHES=(
	"${FILESDIR}"/${PN}-1.75-tinyxml2.patch
	"${FILESDIR}"/${PN}-1.85-ldflags.patch
)

src_prepare() {
	default

	rm -r externals/tinyxml || die
}

src_configure() {
	tc-export CXX PKG_CONFIG
	export LIBS="$(${PKG_CONFIG} --libs tinyxml2)"

	emake dmake
	./dmake || die

	if use pcre ; then
		sed -e '/HAVE_RULES=/s:=no:=yes:' \
			-i Makefile || die
	fi

	if use qt5 ; then
		pushd gui || die
		eqmake5
		popd || die
	fi
}

src_compile() {
	emake ${PN} man \
		CFGDIR="${EROOT}/usr/share/${PN}/cfg" \
		DB2MAN="${EROOT}/usr/share/sgml/docbook/xsl-stylesheets/manpages/docbook.xsl"

	if use qt5 ; then
		pushd gui || die
		emake
		popd || die
	fi

	if use htmlreport ; then
		pushd htmlreport || die
		distutils-r1_src_compile
		popd || die
	fi
}

src_test() {
	# safe final version
	mv -v ${PN}{,.final} || die
	mv -v lib/library.o{,.final} || die
	mv -v cli/cppcheckexecutor.o{,.final} || die
	#trigger recompile with CFGDIR inside ${S}
	emake check CFGDIR="${S}/cfg"
	# restore
	mv -v ${PN}{.final,} || die
	mv -v lib/library.o{.final,} || die
	mv -v cli/cppcheckexecutor.o{.final,} || die
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
		pushd htmlreport || die
		distutils-r1_src_install
		popd || die
		find "${D}" -name "*.egg-info" -delete
	else
		rm "${ED}/usr/bin/cppcheck-htmlreport" || die
	fi
	doman ${PN}.1
	dodoc -r triage
}
