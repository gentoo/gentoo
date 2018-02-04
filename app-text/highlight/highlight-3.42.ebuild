# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic qmake-utils toolchain-funcs

DESCRIPTION="Converts source code to formatted text (HTML, LaTeX, etc.) with syntax highlight"
HOMEPAGE="http://www.andre-simon.de/"
SRC_URI="http://www.andre-simon.de/zip/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="examples qt5"

RDEPEND="
	dev-lang/lua:0=
	qt5? (
		dev-libs/double-conversion:=
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
"
DEPEND="${RDEPEND}
	dev-libs/boost
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

	sed -e "/LSB_DOC_DIR/s:doc/${PN}:doc/${PF}:" \
		-i src/core/datadir.cpp || die

	if has_version "<dev-lang/lua-5.2"; then
		sed -e "s/-DUSE_LUA52//" -i src/makefile || die
	fi

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
	use qt5 && emake -f makefile "${myhlopts[@]}" install-gui

	if ! use examples ; then
		rm -r "${ED}"/usr/share/doc/${PF}/extras || die
	fi
}
