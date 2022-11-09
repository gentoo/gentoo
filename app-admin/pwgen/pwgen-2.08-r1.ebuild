# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Password Generator"
HOMEPAGE="https://sourceforge.net/projects/pwgen/"
SRC_URI="mirror://sourceforge/pwgen/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="livecd"

src_configure() {
	econf --sysconfdir="${EPREFIX}"/etc/pwgen
}

src_install() {
	default

	use livecd && newinitd "${FILESDIR}"/pwgen.rc pwgen
}
