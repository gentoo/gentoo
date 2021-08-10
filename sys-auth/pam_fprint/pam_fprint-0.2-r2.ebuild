# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit pam

DESCRIPTION="a simple PAM module which uses libfprint's functionality for authentication"
HOMEPAGE="http://www.reactivated.net/fprint/wiki/Pam_fprint"
SRC_URI="mirror://sourceforge/fprint/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ppc ppc64 sparc x86"

RDEPEND="
	sys-auth/libfprint:0
	sys-libs/pam"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-headers.patch )

src_install() {
	dopammod src/${PN}.so
	newbin src/pamtest pamtest.fprint
	dobin src/pam_fprint_enroll
	einstalldocs
}
