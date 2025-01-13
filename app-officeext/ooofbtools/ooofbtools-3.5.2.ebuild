# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="OOoFBTools"
MY_PV="3.5.2_r2"
OFFICE_EXTENSIONS=( "${MY_PN}.oxt" )
inherit office-ext-r1

DESCRIPTION="Open/LibreOffice extension for the FictionBook2 format with validation"
HOMEPAGE="https://sourceforge.net/projects/fbtools/"
SRC_URI="https://downloads.sourceforge.net/fbtools/files/release/${MY_PN}-${MY_PV}.zip"
S="${WORKDIR}/${MY_PN}-${PV}"
OFFICE_EXTENSIONS_LOCATION="${S}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	app-arch/zip
	dev-libs/libxml2
"

src_prepare() {
	default

	# Remove Windows cruft
	pushd "${WORKDIR}/${MY_PN}.oxt" &>/dev/null || die
		rm -r win32 || die
	popd &>/dev/null || die
}

src_install() {
	office-ext-r1_src_install
	dodoc ChangeLog*
}
