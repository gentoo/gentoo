# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit bash-completion-r1 go-module

DESCRIPTION="Flux is a tool for keeping Kubernetes clusters in sync"
HOMEPAGE="https://fluxcd.io https://github.com/fluxcd/flux2"
SRC_URI="https://github.com/fluxcd/flux2/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~concord/distfiles/flux2-${PV}-deps.tar.xz"
SRC_URI+=" https://dev.gentoo.org/~concord/distfiles/flux2-${PV}-manifests.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 ISC MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="hardened"

BDEPEND=">=dev-lang/go-1.19"

RESTRICT+=" test"
S="${WORKDIR}/flux2-${PV}"

src_compile() {
	mv "${WORKDIR}"/manifests cmd/"${PN}" || die
	CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')" \
		ego build -ldflags="-s -w -X main.VERSION=${PV}" -o ./bin/${PN} ./cmd/${PN}
}

src_install() {
	dobin bin/${PN}
	bin/${PN} completion bash > ${PN}.bash || die
	bin/${PN} completion zsh > ${PN}.zsh || die
	newbashcomp ${PN}.bash ${PN}
	insinto /usr/share/zsh/site-functions
	newins ${PN}.zsh _${PN}
}
