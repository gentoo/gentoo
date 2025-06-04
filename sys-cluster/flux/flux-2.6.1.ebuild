# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module shell-completion

MY_PN="flux2"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Flux is a tool for keeping Kubernetes clusters in sync"
HOMEPAGE="https://fluxcd.io https://github.com/fluxcd/flux2"
SRC_URI="https://github.com/fluxcd/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/fluxcd/${MY_PN}/releases/download/v${PV}/manifests.tar.gz -> ${P}-manifests.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~concord/distfiles/${MY_P}-deps.tar.xz"
S="${WORKDIR}/${MY_P}"

LICENSE="Apache-2.0 BSD BSD-2 ISC MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="hardened"

BDEPEND=">=dev-lang/go-1.19"

RESTRICT+=" test"

src_unpack() {
	default
	mkdir -p "${S}/cmd/${PN}/manifests" || die
	mv "${WORKDIR}"/*.yaml "${S}/cmd/${PN}/manifests" || die
}

src_compile() {
	CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')" \
		ego build -ldflags="-s -w -X main.VERSION=${PV}" -o ./bin/${PN} ./cmd/${PN}
}

src_install() {
	dobin bin/${PN}
	bin/${PN} completion bash > ${PN}.bash || die
	bin/${PN} completion zsh > ${PN}.zsh || die
	newbashcomp ${PN}.bash ${PN}
	newzshcomp ${PN}.zsh _${PN}
}
