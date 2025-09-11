# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Disk Usage/Free Utility - a better 'df' alternative"
HOMEPAGE="https://github.com/muesli/duf"
SRC_URI="https://github.com/muesli/duf/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-deps.tar.xz"

LICENSE="MIT BSD Apache-2.0"
# Dependent licenses
LICENSE+="  Apache-2.0 BSD MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

src_compile() {
	ego build
}

src_install() {
	dobin duf
	dodoc README.md
	doman duf.1
}
