# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="container signing utility"
HOMEPAGE="https://sigstore.dev"
SRC_URI="https://github.com/sigstore/cosign/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~williamh/dist/${P}-vendor.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

PATCHES=(
	"${FILESDIR}"/${P}-fix-makefile.patch
)

src_prepare() {
	default
	mv ../vendor . || die
}

src_compile() {
	emake \
		GIT_HASH=757252063bf4724f11a52336ef13a724059a39b6 \
		GIT_VERSION=v${PV} \
		GIT_TREESTATE=clean
}

src_install() {
	dobin cosign
}
