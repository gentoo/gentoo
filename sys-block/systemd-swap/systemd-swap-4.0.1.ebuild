# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit linux-info systemd

DESCRIPTION="Script for creating swap space from zram swaps, swap files and swap partitions."
HOMEPAGE="https://github.com/Nefelim4ag/systemd-swap/"

LICENSE="GPL-3"
SLOT="0"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/Nefelim4ag/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/Nefelim4ag/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
fi

CONFIG_CHECK="~ZRAM ~ZSWAP ~CRYPTO_LZ4"

src_install() {
	emake PREFIX="${ED}/" install
}
