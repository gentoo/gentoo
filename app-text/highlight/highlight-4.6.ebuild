# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} luajit )

inherit lua-single qmake-utils toolchain-funcs xdg

DESCRIPTION="Converts source code to formatted text (HTML, LaTeX, etc.) with syntax highlight"
HOMEPAGE="http://www.andre-simon.de/"
SRC_URI="http://www.andre-simon.de/zip/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="examples gui"

REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	${LUA_DEPS}
	gui? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
"
DEPEND="
	${RDEPEND}
	dev-libs/boost
"
BDEPEND="
	virtual/pkgconfig
	gui? ( dev-qt/linguist-tools:5 )
"

PATCHES=(
	"${FILESDIR}"/${PN}-3.57-qt_libs_lua.patch
)

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

	# We set it via eqmake5, otherwise it forces clang...
	sed -e "s/QMAKE_CC/#QMAKE_CC/g" \
		-e "s/QMAKE_CXX /#QMAKE_CXX /g" \
		-i src/gui-qt/highlight.pro || die
}

src_configure() {
	if use gui ; then
		pushd src/gui-qt > /dev/null || die
		eqmake5 \
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
