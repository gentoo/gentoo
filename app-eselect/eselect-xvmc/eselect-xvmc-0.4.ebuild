# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Manages XvMC implementations"
HOMEPAGE="https://www.gentoo.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE=""

DEPEND=""
RDEPEND="app-admin/eselect"

S="${FILESDIR}"

src_install() {
	insinto /usr/share/eselect/modules
	newins "${FILESDIR}"/${P}.eselect xvmc.eselect
}
