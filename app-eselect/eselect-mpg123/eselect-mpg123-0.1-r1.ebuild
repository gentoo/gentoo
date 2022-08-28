# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Manage /usr/bin/mpg123 symlink"
HOMEPAGE="https://www.gentoo.org/proj/en/eselect/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="app-eselect/eselect-lib-bin-symlink"

DEPEND="${RDEPEND}"
S="${FILESDIR}"

src_install() {
	insinto /usr/share/eselect/modules
	newins mpg123.eselect-${PV} mpg123.eselect
}
