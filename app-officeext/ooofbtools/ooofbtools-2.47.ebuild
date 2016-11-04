# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PN="OOoFBTools"

OFFICE_EXTENSIONS=(
	"${MY_PN}.oxt"
)

inherit office-ext-r1

DESCRIPTION="OpenOffice extension for the FictionBook2 format with validation"
HOMEPAGE="https://sourceforge.net/projects/fbtools/"
SRC_URI="mirror://sourceforge/fbtools/files/release/${MY_PN}-${PV}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-libs/libxml2
	app-arch/zip"

S="${WORKDIR}/${MY_PN}-${PV}"

OFFICE_EXTENSIONS_LOCATION="${S}"

src_prepare() {
	# Remove Windows cruft
	pushd "${WORKDIR}/${MY_PN}.oxt" 2>/dev/null || die
	rm -r win32 || die
	popd 2>/dev/null || die
}

src_install() {
	office-ext-r1_src_install
	dodoc ChangeLog*
}
