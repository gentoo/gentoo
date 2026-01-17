# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/alsa.asc
inherit verify-sig

DESCRIPTION="ALSA topology configuration files"
HOMEPAGE="https://alsa-project.org/wiki/Main_Page"
SRC_URI="
	https://www.alsa-project.org/files/pub/lib/${P}.tar.bz2
	verify-sig? ( https://www.alsa-project.org/files/pub/lib/${P}.tar.bz2.sig )
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~sparc x86"

RDEPEND="!<media-libs/alsa-lib-1.2.1"
DEPEND="${RDEPEND}"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-alsa )"

src_install() {
	insinto /usr/share/alsa
	doins -r topology
}
