# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/liborigin/liborigin-20100903.ebuild,v 1.6 2013/03/02 23:23:00 hwoarang Exp $

EAPI="3"

inherit eutils qt4-r2

DESCRIPTION="Library for reading OriginLab OPJ project files"
HOMEPAGE="http://soft.proindependent.com/liborigin2/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="2"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND="dev-libs/boost"
DEPEND="${RDEPEND}
	dev-qt/qtgui:4
	dev-cpp/tree
	doc? ( app-doc/doxygen )"

PATCHES=(
	"${FILESDIR}/liborigin-20100420-build-parsers.patch"
	)

DOCS="readme FORMAT"

src_prepare() {
	qt4-r2_src_prepare
	cat >> liborigin.pro <<-EOF
		INCLUDEPATH += "${EPREFIX}/usr/include/tree"
		headers.files = \$\$HEADERS
		headers.path = "${EPREFIX}/usr/include/liborigin2"
		target.path = "${EPREFIX}/usr/$(get_libdir)"
		INSTALLS = target headers
	EOF
	# use system one
	rm -f tree.hh || die
}

src_compile() {
	qt4-r2_src_compile
	if use doc; then
		cd doc
		doxygen Doxyfile || die "doc generation failed"
	fi
}

src_install() {
	qt4-r2_src_install
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins -r doc/html || die "doc install failed"
	fi
}
