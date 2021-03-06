# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Userspace utilities for new exfat filesystem (kernel 5.7+)"
HOMEPAGE="https://github.com/exfatprogs/exfatprogs"
if [[ "${PV}" == *9999 ]] ; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://github.com/exfatprogs/exfatprogs.git"
else
	SRC_URI="https://github.com/${PN}/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ppc64 x86"
fi
LICENSE="GPL-2"
SLOT="0"

IUSE=""

RDEPEND="!sys-fs/exfat-utils"

src_prepare() {
	default
	[[ "${PV}" == *9999 ]] && eautoreconf
}
