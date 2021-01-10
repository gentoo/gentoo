# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Run programs on the discrete nVidia video card"
HOMEPAGE="https://github.com/archlinux/svntogit-packages/tree/packages/nvidia-prime/trunk https://archlinux.org/packages/extra/any/nvidia-prime/"
SRC_URI="https://raw.githubusercontent.com/archlinux/svntogit-packages/packages/nvidia-prime/trunk/prime-run -> ${P}"

# https://github.com/archlinux/svntogit-packages/blob/packages/nvidia-prime/trunk/PKGBUILD
LICENSE="GPL-1"
SLOT="0"
KEYWORDS="amd64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}"

src_install() {
	newbin "${DISTDIR}"/${P} ${PN}
}
