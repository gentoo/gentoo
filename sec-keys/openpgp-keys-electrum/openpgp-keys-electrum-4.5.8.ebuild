# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P=electrum-${PV}
DESCRIPTION="OpenPGP keys for net-misc/electrum releases"
HOMEPAGE="https://electrum.org/#download"
SRC_URI="
	https://github.com/spesmilo/electrum/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	local keys=(
		pubkeys/ThomasV.asc
		pubkeys/sombernight_releasekey.asc
		pubkeys/Emzy.asc
	)

	insinto /usr/share/openpgp-keys
	newins - electrum.asc < <(cat "${keys[@]}")
}
