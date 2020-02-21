# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="FUSE implementation for overlayfs"
HOMEPAGE="https://github.com/containers/fuse-overlayfs"
EGIT_COMMIT="99d49d54aea94fea4e57ef5287eaa9e1e092de7f"
SRC_URI="https://github.com/containers/fuse-overlayfs/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=sys-fs/fuse-3:="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

src_prepare() {
	default
	eautoreconf
}
