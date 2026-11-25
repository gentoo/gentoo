# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module shell-completion sysroot

GIT_COMMIT=a8f5d1cb

DESCRIPTION="Tool to move from docker-compose to Kubernetes"
HOMEPAGE="https://kompose.io https://github.com/kubernetes/kompose"
SRC_URI="https://github.com/kubernetes/kompose/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-golang-dist/${PN}/releases/download/v${PV}/${P}-vendor.tar.xz"

LICENSE="Apache-2.0"
# Dependent licenses
LICENSE+=" Apache-2.0 BSD BSD-2 MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	local -x CGO_ENABLED=0
	local myegoargs=(
		-ldflags="-X github.com/kubernetes/kompose/pkg/version.GITCOMMIT=${GIT_COMMIT}"
	)
	ego build "${myegoargs[@]}" -o ${PN} main.go

	einfo "generating shell completion files"
	sysroot_try_run_prefixed ./kompose completion bash > ${PN}.bash || die
	sysroot_try_run_prefixed ./kompose completion zsh > ${PN}.zsh || die
	sysroot_try_run_prefixed ./kompose completion fish > ${PN}.fish || die
}

src_test() {
	ego test -v ./...
}

src_install() {
	dobin ${PN}
	dodoc -r docs README.md

	[[ -s ${PN}.bash ]] && newbashcomp ${PN}.bash ${PN}
	[[ -s ${PN}.zsh ]] && newzshcomp ${PN}.zsh _${PN}
	[[ -s ${PN}.fish ]] && dofishcomp ${PN}.fish
}
