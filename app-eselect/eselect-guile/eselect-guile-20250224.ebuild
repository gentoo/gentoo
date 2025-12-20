# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="GNU Guile eselect module"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos"

RDEPEND="app-admin/eselect"

src_install() {
	insinto /usr/share/eselect/modules/
	newins "${FILESDIR}"/guile-"${PV}".eselect guile.eselect
}
