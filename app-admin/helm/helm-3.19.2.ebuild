# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module toolchain-funcs shell-completion

GIT_COMMIT=8766e718a0119851f10ddbe4577593a45fadf544

DESCRIPTION="Kubernetes Package Manager"
HOMEPAGE="https://helm.sh https://github.com/helm/helm"
SRC_URI="https://github.com/helm/helm/archive/v${PV}.tar.gz -> k8s-${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-golang-dist/${PN}/releases/download/v${PV}/${P}-vendor.tar.xz"

LICENSE="Apache-2.0"
# Dependent licenses
LICENSE+=" Apache-2.0 BSD BSD-2 ISC MIT MPL-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~loong ~riscv"
RESTRICT="test"

src_compile() {
	emake \
		GOFLAGS="${GOFLAGS}" \
		LDFLAGS="" \
		GIT_COMMIT=${GIT_COMMIT} \
		GIT_SHA=${GIT_COMMIT::8} \
		GIT_TAG=v${MY_PV} \
		GIT_DIRTY=clean \
		build

	if ! tc-is-cross-compiler; then
		einfo "generating shell completion files"
		bin/${PN} completion bash > ${PN}.bash || die
		bin/${PN} completion zsh > ${PN}.zsh || die
		bin/${PN} completion fish > ${PN}.fish || die
	fi
}

src_install() {
	dobin bin/${PN}
	einstalldocs

	if ! tc-is-cross-compiler; then
		newbashcomp ${PN}.bash ${PN}
		newzshcomp ${PN}.zsh _${PN}
		dofishcomp ${PN}.fish
	else
		ewarn "Shell completion files not installed! Install them manually with '${PN} completion --help'"
	fi
}
