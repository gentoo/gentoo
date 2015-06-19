# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/sil-gentium/sil-gentium-1.508.ebuild,v 1.3 2013/10/21 12:17:50 grobian Exp $

EAPI="4"

inherit font

MY_PN="GentiumPlus"

DESCRIPTION="SIL Gentium Plus unicode font for Latin and Greek languages"
HOMEPAGE="http://scripts.sil.org/gentium"
SRC_URI="mirror://gentoo/${MY_PN}-${PV}.zip
	compact? ( mirror://gentoo/${MY_PN}Compact-${PV}.zip )"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~ppc-macos ~x64-macos ~x86-macos"
IUSE="compact doc"

DEPEND="app-arch/unzip"
RDEPEND=""

DOCS="GENTIUM-FAQ.txt OFL-FAQ.txt"
FONT_SUFFIX="ttf"

S="${WORKDIR}/${MY_PN}-${PV}"
FONT_S="${S}"

src_unpack() {
	unpack ${A}

	if use compact; then
		mv "${WORKDIR}"/${MY_PN}Compact-${PV}/*.${FONT_SUFFIX} "${FONT_S}" || die
	fi
}

src_install() {
	font_src_install
	use doc && dodoc -r "${S}"/documentation
}
