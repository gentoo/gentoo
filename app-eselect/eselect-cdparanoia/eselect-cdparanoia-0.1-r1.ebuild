# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Manage /usr/bin/cdparanoia symlink"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Eselect"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

RDEPEND="app-eselect/eselect-lib-bin-symlink"

src_install() {
	insinto /usr/share/eselect/modules
	newins "${FILESDIR}"/cdparanoia.eselect-${PV} cdparanoia.eselect
}
