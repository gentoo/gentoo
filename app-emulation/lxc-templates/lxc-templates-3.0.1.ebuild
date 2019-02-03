# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Old style template scripts for LXC"
HOMEPAGE="https://linuxcontainers.org/"
SRC_URI="https://linuxcontainers.org/downloads/lxc/${P}.tar.gz"

KEYWORDS="amd64 ~arm ~arm64 ppc64 x86"

LICENSE="LGPL-3"
SLOT="0"

RDEPEND="
	>=app-emulation/lxc-3.0"

DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${P}-no-cache-dir.patch" )
DOCS=()

src_prepare() {
	default
	eautoreconf
}
