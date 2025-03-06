# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Docker CLI plugin for extended build capabilities with BuildKit"
HOMEPAGE="https://github.com/docker/buildx"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/docker/buildx.git"
else
	SRC_URI="https://github.com/docker/buildx/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
	S=${WORKDIR}/${P#docker-}
fi

LICENSE="Apache-2.0"
# Dependent licenses
LICENSE+=" Apache-2.0 BSD BSD-2 ISC MIT MPL-2.0"
SLOT="0"

RDEPEND="app-containers/docker-cli"

src_compile() {
	local _buildx_r='github.com/docker/buildx'
	local version=${PV}
	if [[ ${PV} == 9999 ]]; then
		version="$(git rev-parse --short HEAD)"
	fi
	local go_ldflags=(
		"-linkmode=external"
		-X "${_buildx_r}/version.Version=${version}"
		-X "${_buildx_r}/version.Revision=$(date -u +%FT%T%z)"
		-X "${_buildx_r}/version.Package=${_buildx_r}"
	)
	ego build -o docker-buildx -ldflags "${go_ldflags[*]}" ./cmd/buildx
}

src_test() {
	# TestGit can't work in a source tarball; TestReadTargets fails seemingly due to parallelism.
	if [[ ${PV} == 9999 ]]; then
		ego test ./... -skip "TestReadTargets|TestIntegration"
	else
		ego test ./... -skip "TestGit|TestReadTargets|TestIntegration"
	fi
}

src_install() {
	exeinto /usr/libexec/docker/cli-plugins
	doexe docker-buildx

	einstalldocs
}
