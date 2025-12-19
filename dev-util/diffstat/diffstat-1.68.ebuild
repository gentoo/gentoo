# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/thomasdickey.asc
inherit verify-sig

DESCRIPTION="Display a histogram of diff changes"
HOMEPAGE="https://invisible-island.net/diffstat/"
SRC_URI="https://invisible-mirror.net/archives/${PN}/${P}.tgz"
SRC_URI+=" verify-sig? ( https://invisible-island.net/archives/${PN}/${P}.tgz.asc )"

LICENSE="HPND MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

BDEPEND="verify-sig? ( >=sec-keys/openpgp-keys-thomasdickey-20240114 )"
