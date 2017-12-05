# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs qt4-r2 flag-o-matic

DESCRIPTION="Converts source code to formatted text (HTML, LaTeX, etc.) with syntax highlight"
HOMEPAGE="http://www.andre-simon.de/"
SRC_URI="http://www.andre-simon.de/zip/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="examples qt4"

RDEPEND="dev-lang/lua:0=
	qt4? (
		dev-qt/qtgui:4
		dev-qt/qtcore:4
	)"
DEPEND="${RDEPEND}
	dev-libs/boost
	virtual/pkgconfig"

src_prepare() {
	sed -i "/LSB_DOC_DIR/s:doc/${PN}:doc/${PF}:" \
		src/core/datadir.cpp || die

	if has_version '<dev-lang/lua-5.2' ; then
		sed -i 's/-DUSE_LUA52//' src/makefile || die
	fi

	# We set it via eqmake4, otherwise it forces clang...
	sed -e 's/QMAKE_CC/#QMAKE_CC/g' \
		-e 's/QMAKE_CXX /#QMAKE_CXX /g' \
		-i "${S}/src/gui-qt/highlight.pro" || die
}

src_compile() {
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
	emake -f makefile "${myhlopts[@]}"
	if use qt4 ; then
		cd src/gui-qt
		eqmake4 'DEFINES+=DATA_DIR=\\\"'"${EPREFIX}"'/usr/share/${PN}/\\\" CONFIG_DIR=\\\"'"${EPREFIX}"'/etc/${PN}/\\\" DOC_DIR=\\\"'"${EPREFIX}"'/usr/share/doc/${PF}/\\\"'
		emake
	fi
}

src_install() {
	emake -f makefile "${myhlopts[@]}" install
	use qt4 && emake -f makefile "${myhlopts[@]}" install-gui

	if use examples ; then
		docompress -x /usr/share/doc/${PF}/examples
	else
		rm -rf "${ED}"/usr/share/doc/${PF}/examples
	fi
}
