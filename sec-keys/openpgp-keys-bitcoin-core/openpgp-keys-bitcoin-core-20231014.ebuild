# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MyPN="guix.sigs"
DESCRIPTION="OpenPGP keys used to sign Bitcoin Core releases"
HOMEPAGE="https://bitcoincore.org/"
COMMIT_HASH=a21b279ea9d457630cd01a190652947b0e567875
SRC_URI="https://github.com/bitcoin-core/${MyPN}/archive/${COMMIT_HASH}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MyPN}-${COMMIT_HASH}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 loong m68k mips ppc ppc64 riscv s390 sparc x86"

src_install() {
	insinto /usr/share/openpgp-keys
	newins - bitcoin-core.asc < <(cat builder-keys/*.gpg)
}
