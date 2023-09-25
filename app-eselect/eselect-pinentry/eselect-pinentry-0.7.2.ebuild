# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Manage /usr/bin/pinentry symlink"
HOMEPAGE="https://www.gentoo.org/proj/en/eselect/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE=""

RDEPEND=">=app-eselect/eselect-lib-bin-symlink-0.1.1"

S="${FILESDIR}"

src_install() {
	default
	insinto /usr/share/eselect/modules
	newins pinentry.eselect-${PV} pinentry.eselect
}
