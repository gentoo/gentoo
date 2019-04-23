# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Redistributable headers to build cuvid and nvenc"
HOMEPAGE="https://github.com/lu-zero/nvidia-video-codec"
SRC_URI="https://github.com/lu-zero/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-util/nvidia-cuda-toolkit-7.5
		>=x11-drivers/nvidia-drivers-367.35"
RDEPEND="${DEPEND}"

src_install() {
	insinto /opt/${PN}/include
	doins *.h
	dodoc README.md
}
