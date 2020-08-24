# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils toolchain-funcs

DESCRIPTION="Converts source code to formatted text (HTML, LaTeX, etc.) with syntax highlight"
HOMEPAGE="http://www.andre-simon.de/"
SRC_URI="http://www.andre-simon.de/zip/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="examples qt5"

RDEPEND="
	|| ( dev-lang/lua:0 dev-lang/lua:5.3 dev-lang/lua:5.2 dev-lang/lua:5.1 )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
"
DEPEND="${RDEPEND}
	dev-libs/boost
"
BDEPEND="
	virtual/pkgconfig
	qt5? ( dev-qt/linguist-tools:5 )
"

myhlopts=(
	"CXX=$(tc-getCXX)"
	"AR=$(tc-getAR)"
	"LDFLAGS=${LDFLAGS}"
	"CFLAGS=${CXXFLAGS} -DNDEBUG -std=c++11"
	"DESTDIR=${D}"
	"PREFIX=${EPREFIX}/usr"
	"HL_CONFIG_DIR=${EPREFIX}/etc/highlight/"
	"HL_DATA_DIR=${EPREFIX}/usr/share/highlight/"
	"doc_dir=${EPREFIX}/usr/share/doc/${PF}/"
	"conf_dir=${EPREFIX}/etc/highlight/"
)

src_prepare() {
	default

	# disable man page compression
	sed -e "/GZIP/d" -i makefile || die

	sed -e "/LSB_DOC_DIR/s:doc/${PN}:doc/${PF}:" \
		-i src/core/datadir.cpp || die

	# Use the correct pkgconfig name for Lua
	# Upstream codebase supports up to and including Lua 5.3!
	if has_version 'dev-lang/lua:5.3'; then
		LUAPKGCONFIG=lua5.3
	elif has_version 'dev-lang/lua:5.2'; then
		LUAPKGCONFIG=lua5.2
	elif has_version 'dev-lang/lua:5.1'; then
		LUAPKGCONFIG=lua5.1
	elif has_version 'dev-lang/lua:0'; then
		LUAPKGCONFIG=lua
	else
		die "Could not detect Lua version"
	fi
	einfo "Using pkg-config ${LUAPKGCONFIG}"
	sed -r -i \
		-e "/^LUA_.*pkg-config/s,\<lua\>,${LUAPKGCONFIG},g" \
		"${S}"/extras/tcl/makefile \
		"${S}"/extras/swig/makefile \
		"${S}"/makefile \
		"${S}"/src/makefile \
		|| die "Failed to set Lua version"

	# We set it via eqmake5, otherwise it forces clang...
	sed -e "s/QMAKE_CC/#QMAKE_CC/g" \
		-e "s/QMAKE_CXX /#QMAKE_CXX /g" \
		-i src/gui-qt/highlight.pro || die
}

src_configure() {
	if use qt5 ; then
		pushd src/gui-qt > /dev/null || die
		eqmake5 \
			'DEFINES+=DATA_DIR=\\\"'"${EPREFIX}"'/usr/share/${PN}/\\\" CONFIG_DIR=\\\"'"${EPREFIX}"'/etc/${PN}/\\\" DOC_DIR=\\\"'"${EPREFIX}"'/usr/share/doc/${PF}/\\\"'
		popd > /dev/null || die
	fi
}

src_compile() {
	emake -f makefile "${myhlopts[@]}"
	if use qt5 ; then
		pushd src/gui-qt > /dev/null || die
		emake
		popd > /dev/null || die
	fi
}

src_install() {
	emake -f makefile "${myhlopts[@]}" install
	if use qt5; then
		emake -f makefile "${myhlopts[@]}" install-gui
		docompress -x /usr/share/doc/${PF}/{ChangeLog,COPYING,README,README_PLUGINS}
	fi

	if ! use examples ; then
		rm -r "${ED}"/usr/share/doc/${PF}/extras || die
	fi
}
