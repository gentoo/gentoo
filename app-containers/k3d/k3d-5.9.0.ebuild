# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module shell-completion sysroot

K3D_K3S_TAG=v1.36.1-k3s1

DESCRIPTION="k3d creates k3s clusters in docker"
HOMEPAGE="https://github.com/rancher/k3d"
SRC_URI="https://github.com/rancher/k3d/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT Apache-2.0 BSD BSD-2 MPL-2.0 ISC"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

BDEPEND=">=dev-lang/go-1.26.3"

src_compile() {
	local ldflags=(
		-w
		-X "github.com/k3d-io/k3d/v5/version.Version=v${PV}"
		-X "github.com/k3d-io/k3d/v5/version.K3sVersion=${K3D_K3S_TAG}"
	)
	local -x GOWORK="" CGO_ENABLED=1
	ego build -ldflags "${ldflags[*]}" -o bin/k3d

	einfo "generating shell completion files"
	sysroot_try_run_prefixed ./bin/k3d completion bash > ${PN}.bash || die
	sysroot_try_run_prefixed ./bin/k3d completion zsh > ${PN}.zsh || die
	sysroot_try_run_prefixed ./bin/k3d completion fish > ${PN}.fish || die
}

src_test() {
	ego test -v ./... -skip "TestGetK3sVersion"
}

src_install() {
	dobin bin/${PN}

	[[ -s ${PN}.bash ]] && newbashcomp ${PN}.bash ${PN}
	[[ -s ${PN}.zsh ]] && newzshcomp ${PN}.zsh _${PN}
	[[ -s ${PN}.fish ]] && dofishcomp ${PN}.fish

	DOCS=( *.md )
	use doc && DOCS+=( docs )
	einstalldocs
}
