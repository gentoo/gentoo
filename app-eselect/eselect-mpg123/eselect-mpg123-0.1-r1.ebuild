# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Manage /usr/bin/mpg123 symlink"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Eselect"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="app-eselect/eselect-lib-bin-symlink"

src_install() {
	insinto /usr/share/eselect/modules
	newins "${FILESDIR}"/mpg123.eselect-${PV} mpg123.eselect
}
