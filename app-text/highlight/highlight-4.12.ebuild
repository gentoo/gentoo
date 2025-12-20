# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} luajit )
VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/andresimon.asc
inherit lua-single qmake-utils toolchain-funcs verify-sig xdg

DESCRIPTION="Converts source code to formatted text (HTML, LaTeX, etc.) with syntax highlight"
HOMEPAGE="http://andre-simon.de/"
# This is arbitrary; upstream uses master.  Update when possible.
TESTSUITE_COMMIT="a3479468672cdbc570a17ae84e047fe8f0b88798"
SRC_URI="
	http://andre-simon.de/zip/${P}.tar.bz2
	test? ( https://gitlab.com/tajmone/${PN}-test-suite/-/archive/${TESTSUITE_COMMIT}/${PN}-test-suite-${TESTSUITE_COMMIT}.tar.bz2 )
	verify-sig? ( http://www.andre-simon.de/zip/${P}.tar.bz2.asc )
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="examples gui test"

REQUIRED_USE="${LUA_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="${LUA_DEPS}
	gui? ( dev-qt/qtbase:6[gui,widgets] )
"
DEPEND="${RDEPEND}
	dev-libs/boost
"
BDEPEND="
	virtual/pkgconfig
	gui? ( dev-qt/qttools:6[linguist] )
	verify-sig? ( sec-keys/openpgp-keys-andresimon )
"

PATCHES=( "${FILESDIR}"/${PN}-3.57-qt_libs_lua.patch )

myhlopts=(
	CXX="$(tc-getCXX)"
	AR="$(tc-getAR)"
	LDFLAGS="${LDFLAGS}"
	CFLAGS="${CXXFLAGS} -DNDEBUG"
	DESTDIR="${D}"
	PREFIX="${EPREFIX}/usr"
	HL_CONFIG_DIR="${EPREFIX}/etc/highlight/"
	HL_DATA_DIR="${EPREFIX}/usr/share/highlight/"
	doc_dir="${EPREFIX}/usr/share/doc/${PF}/"
	conf_dir="${EPREFIX}/etc/highlight/"
	examples_dir="${EPREFIX}/usr/share/doc/${PF}/extras"
)

src_unpack() {
	if use verify-sig ; then
		# Needed because the testsuite tarball is unsigned
		verify-sig_verify_detached "${DISTDIR}"/${P}.tar.bz2{,.asc}
	fi

	default
}

src_prepare() {
	default

	# Disable man page compression
	sed \
		-e "/GZIP/d" \
		-e "/COPYING/d" \
		-i makefile || die

	sed -e "/LSB_DOC_DIR/s:doc/${PN}:doc/${PF}:" \
		-i src/core/datadir.cpp || die

	sed -r -i \
		-e "/^LUA_.*pkg-config/s,\<lua\>,${ELUA},g" \
		"${S}"/extras/tcl/makefile \
		"${S}"/extras/swig/makefile \
		|| die "Failed to set Lua implementation"

	# We set it via eqmake6, otherwise it forces clang...
	sed -e "s/QMAKE_CC/#QMAKE_CC/g" \
		-e "s/QMAKE_CXX /#QMAKE_CXX /g" \
		-i src/gui-qt/highlight.pro || die
}

src_configure() {
	if use gui ; then
		pushd src/gui-qt > /dev/null || die
		eqmake6 \
			'DEFINES+=DATA_DIR=\\\"'"${EPREFIX}"'/usr/share/${PN}/\\\" CONFIG_DIR=\\\"'"${EPREFIX}"'/etc/${PN}/\\\" DOC_DIR=\\\"'"${EPREFIX}"'/usr/share/doc/${PF}/\\\"'
		popd > /dev/null || die
	fi
}

src_compile() {
	emake -f makefile LUA_PKG_NAME="${ELUA}" "${myhlopts[@]}"
	if use gui ; then
		emake -C src/gui-qt
	fi
}

src_test() {
	find "../${PN}-test-suite-${TESTSUITE_COMMIT}" -mindepth 1 -maxdepth 1 -type d | sort | while read line
	do
		"${SHELL}" "${line}/regression.sh" || die "Regression tests failed for language $(basename "${line}")"
	done
}

src_install() {
	emake -f makefile "${myhlopts[@]}" install

	if use gui; then
		emake -f makefile "${myhlopts[@]}" install-gui
		docompress -x /usr/share/doc/${PF}/{ChangeLog,COPYING,README,README_PLUGINS}
	fi

	if ! use examples ; then
		rm -r "${ED}"/usr/share/doc/${PF}/extras || die
	fi
}
