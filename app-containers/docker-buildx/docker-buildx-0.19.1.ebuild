# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

MY_PN="buildx"
DESCRIPTION="Docker CLI plugin for extended build capabilities with BuildKit"
HOMEPAGE="https://github.com/docker/buildx"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/docker/buildx.git"
else
	SRC_URI="https://github.com/docker/buildx/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

LICENSE="Apache-2.0"
SLOT="0"

IUSE="test"

# This gives us the ability to neatly `-skip` tests.
# not required once ::gentoo is all > 1.20
RESTRICT="!test? ( test )"

BDEPEND="
	test? ( >=dev-lang/go-1.20 )
"
RDEPEND="app-containers/docker-cli"

src_compile() {
	local _buildx_r='github.com/docker/buildx'
	local version=${PV}
	if [[ ${PV} == 9999 ]]; then
		version="$(git rev-parse --short HEAD)"
	fi
	ego build -o docker-buildx \
		-ldflags "-linkmode=external
		-X $_buildx_r/version.Version=${version}
		-X $_buildx_r/version.Revision=$(date -u +%FT%T%z)
		-X $_buildx_r/version.Package=$_buildx_r" \
		./cmd/buildx
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

	dodoc README.md
}
