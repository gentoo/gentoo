# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module toolchain-funcs shell-completion

GIT_COMMIT=9532ceef

DESCRIPTION="Tool to move from docker-compose to Kubernetes"
HOMEPAGE="https://github.com/kubernetes/kompose https://kompose.io"
SRC_URI="https://github.com/kubernetes/kompose/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~arthurzam/distfiles/app-containers/${PN}/${P}-deps.tar.xz"

LICENSE="Apache-2.0"
# Dependent licenses
LICENSE+=" BSD BSD-2 MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	local -x CGO_ENABLED=0
	local myegoargs=(
		-ldflags="-X github.com/kubernetes/kompose/pkg/version.GITCOMMIT=${GIT_COMMIT}"
	)
	ego build "${myegoargs[@]}" -o ${PN} main.go

	if ! tc-is-cross-compiler; then
		elog "generating shell completion files"
		./kompose completion bash > ${PN}.bash || die
		./kompose completion zsh > ${PN}.zsh || die
		./kompose completion fish > ${PN}.fish || die
	fi
}

src_test() {
	ego test -v ./...
}

src_install() {
	dobin ${PN}
	dodoc -r docs README.md

	if ! tc-is-cross-compiler; then
		newbashcomp ${PN}.bash ${PN}
		newzshcomp ${PN}.zsh _${PN}
		dofishcomp ${PN}.fish
	else
		ewarn "Shell completion files not installed! Install them manually with '${PN} completion --help'"
	fi
}
