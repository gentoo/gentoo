# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib qt4-r2

DESCRIPTION="Library for reading OriginLab OPJ project files"
HOMEPAGE="http://soft.proindependent.com/liborigin2/"
SRC_URI="http://dev.gentoo.org/~dilfridge/distfiles/${PN}2-${PV}.zip"

LICENSE="GPL-3"
SLOT="2"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND="
	dev-libs/boost
	dev-qt/qtgui:4"
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-cpp/tree
	doc? ( app-doc/doxygen )"

S="${WORKDIR}"/${PN}${SLOT}

src_prepare() {
	mv liborigin2.pro liborigin.pro || die
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
		cd doc && \
			doxygen Doxyfile || die "doc generation failed"
	fi
}

src_install() {
	local DOCS="readme FORMAT"
	use doc && local HTML_DOCS=( doc/html/. )
	qt4-r2_src_install
}
