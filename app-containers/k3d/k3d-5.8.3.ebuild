# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit shell-completion go-module

K3D_K3S_TAG=v1.31.5-k3s1

DESCRIPTION="k3d creates k3s clusters in docker"
HOMEPAGE="https://github.com/rancher/k3d"
SRC_URI="https://github.com/rancher/k3d/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT Apache-2.0 BSD BSD-2 MPL-2.0 ISC"
SLOT="0"
KEYWORDS="amd64"
IUSE="doc"

src_prepare() {
	default
	rm Makefile || die
}

src_compile() {
	local ldflags=(
		-w -s
		-X "github.com/k3d-io/k3d/v5/version.Version=v${PV}"
		-X "github.com/k3d-io/k3d/v5/version.K3sVersion=${K3D_K3S_TAG}"
	)
	local -x GOWORK="" CGO_ENABLED=1
	ego build -mod=vendor -ldflags "${ldflags[*]}" -o bin/k3d

	./bin/k3d completion bash > ${PN}.bash || die
	./bin/k3d completion zsh > ${PN}.zsh || die
	./bin/k3d completion fish > ${PN}.fish || die
}

src_test() {
	ego test -v ./... -skip "TestGetK3sVersion"
}

src_install() {
	dobin bin/${PN}

	newbashcomp ${PN}.bash ${PN}
	newzshcomp ${PN}.zsh _${PN}
	dofishcomp ${PN}.fish

	DOCS=( *.md )
	use doc && DOCS+=( docs )
	default_src_install
}
