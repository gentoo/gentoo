# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module shell-completion

DESCRIPTION="kubectl plugin for Kubernetes OpenID Connect authentication"
HOMEPAGE="https://github.com/int128/kubelogin"
SRC_URI="https://github.com/int128/kubelogin/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~concord/distfiles/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 ISC MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

src_prepare() {
	default

	# -buildmode=pie not supported when -race is enabled
	if [[ ${GOFLAGS} == *buildmode=pie* ]]; then
		sed -e 's/ -race / /' -i Makefile || die
	fi
}

src_compile() {
	ego build -ldflags="-s -w" -o ./bin/${PN} .
}

src_install() {
	newbin bin/${PN} "kubectl-oidc_login"
	bin/${PN} completion bash > ${PN}.bash || die
	bin/${PN} completion zsh > ${PN}.zsh || die
	newbashcomp ${PN}.bash ${PN}
	newzshcomp ${PN}.zsh _${PN}
}
