# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

MY_PN="sealed-secrets"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Client-side utility for one-way encrypted secrets in kubernetes"
HOMEPAGE="https://github.com/bitnami-labs/sealed-secrets"
SRC_URI="https://github.com/bitnami-labs/sealed-secrets/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~concord/distfiles/${MY_P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD ISC MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="hardened"

BDEPEND=">=dev-lang/go-1.19"

RESTRICT+=" test"
S="${WORKDIR}/${MY_P}"

src_compile() {
	CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')" \
		emake -j1 GOFLAGS="" GOLDFLAGS="" LDFLAGS="" VERSION="v${PV}" ${PN}
}

src_install() {
	dobin ${PN}
}
