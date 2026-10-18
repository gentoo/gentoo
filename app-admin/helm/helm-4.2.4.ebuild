# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module shell-completion sysroot

GIT_COMMIT=3900f434fd3ef2b84065dc04508df48f288dba00

DESCRIPTION="Kubernetes Package Manager"
HOMEPAGE="https://helm.sh https://github.com/helm/helm"
SRC_URI="https://github.com/helm/helm/archive/v${PV}.tar.gz -> k8s-${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-golang-dist/${PN}/releases/download/v${PV}/${P}-vendor.tar.xz"

LICENSE="Apache-2.0"
# Dependent licenses
LICENSE+=" Apache-2.0 BSD BSD-2 ISC MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv"
RESTRICT="test"

BDEPEND=">=dev-lang/go-1.26.0"

src_prepare() {
	default
	sed -e '/^build:/s/ tidy//' -i Makefile || die
}

src_compile() {
	local emakeargs=(
		GOFLAGS="${GOFLAGS}"
		LDFLAGS=""
		GIT_COMMIT=${GIT_COMMIT}
		GIT_SHA=${GIT_COMMIT::8}
		GIT_TAG=v${MY_PV}
		GIT_DIRTY=clean
	)
	emake "${emakeargs[@]}" build

	einfo "generating shell completion files"
	sysroot_try_run_prefixed bin/${PN} completion bash > ${PN}.bash || die
	sysroot_try_run_prefixed bin/${PN} completion zsh > ${PN}.zsh || die
	sysroot_try_run_prefixed bin/${PN} completion fish > ${PN}.fish || die
}

src_install() {
	dobin bin/${PN}
	einstalldocs

	[[ -s ${PN}.bash ]] && newbashcomp ${PN}.bash ${PN}
	[[ -s ${PN}.zsh ]] && newzshcomp ${PN}.zsh _${PN}
	[[ -s ${PN}.fish ]] && dofishcomp ${PN}.fish
}
