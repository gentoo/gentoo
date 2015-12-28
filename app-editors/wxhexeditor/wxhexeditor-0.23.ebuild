# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PLOCALES="ar cs de es fr hu_HU it ja_JP nl_NL pl pt_BR ro ru tr zh_CN"

inherit eutils l10n toolchain-funcs wxwidgets

MY_PN="wxHexEditor"

DESCRIPTION="A cross-platform hex editor designed specially for large files"
HOMEPAGE="http://wxhexeditor.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}-v${PV}-src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	app-crypt/mhash
	dev-libs/udis86
	x11-libs/wxGTK:3.0[X]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}"

pkg_pretend() {
	tc-has-openmp \
		|| die "${PN} uses OpenMP libraries. Please use an OpenMP-capable compiler."
}

src_prepare() {
	WX_GTK_VER="3.0" need-wxwidgets unicode
	epatch "${FILESDIR}"/${P}-syslibs.patch

	do_kill_locale() {
		rm -r "${S}"/locale/${1}
	}

	rm "${S}"/locale/wxHexEditor.pot
	l10n_find_plocales_changes "${S}"/locale '' ''
	l10n_for_each_disabled_locale_do do_kill_locale
}
