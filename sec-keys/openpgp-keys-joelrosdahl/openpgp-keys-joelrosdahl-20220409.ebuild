# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by Joel Rosdahl"
HOMEPAGE="https://ccache.dev/download.html"
# Mirrored from https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x5a939a71a46792cf57866a51996dda075594adb8
# (https://pgp.key-server.io/pks/lookup?search=0x5A939A71A46792CF57866A51996DDA075594ADB8&fingerprint=on&op=vindex was down)
SRC_URI="https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-0x5A939A71A46792CF57866A51996DDA075594ADB8.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - joelrosdahl.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
