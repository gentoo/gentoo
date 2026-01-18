# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/tytso.asc
inherit verify-sig

DESCRIPTION="Password Generator"
HOMEPAGE="https://sourceforge.net/projects/pwgen/"
SRC_URI="
	https://downloads.sourceforge.net/pwgen/${P}.tar.gz
	verify-sig? ( https://downloads.sourceforge.net/pwgen/${P}.tar.gz.asc )
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="livecd"

BDEPEND="
	verify-sig? ( sec-keys/openpgp-keys-tytso )
"

PATCHES=(
	"${FILESDIR}"/${P}-c2x.patch
)

src_configure() {
	econf --sysconfdir="${EPREFIX}"/etc/pwgen
}

src_install() {
	default

	use livecd && newinitd "${FILESDIR}"/pwgen.rc pwgen
}
