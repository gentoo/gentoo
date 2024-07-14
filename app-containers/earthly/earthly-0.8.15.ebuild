# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Git commit SHA is needed at runtime by earthly to pull and bootstrap images.
if [[ "${PV}" == "0.8.15" ]] ; then
	COMMIT_SHA="cb38f72663696d17d8393b1cc8bac66aed28faa2"
else
	die 'Could not detect "COMMIT_SHA", please update the ebuild.'
fi

inherit go-module

DESCRIPTION="Build automation tool that executes in containers"
HOMEPAGE="https://earthly.dev/
	https://github.com/earthly/earthly/"
SRC_URI="
	https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz
	https://dev.gentoo.org/~xgqt/distfiles/deps/${P}-deps.tar.xz
"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	|| (
		app-containers/docker
		app-containers/podman
	)
"

DOCS=( CHANGELOG.md CONTRIBUTING.md README.md )

src_compile() {
	local -r go_tags="dfrunmount,dfrunsecurity,dfsecrets,dfssh,dfrunnetwork,dfheredoc,forceposix"
	local -r go_ldflags="
		-X main.DefaultBuildkitdImage=docker.io/earthly/buildkitd:v${PV}
		-X main.GitSha=${COMMIT_SHA}
		-X main.Version=v${PV}
	"
	local -a -r go_buildargs=(
		-tags "${go_tags}"
		-ldflags "${go_ldflags}"
		-o ./bin/
	)
	ego build "${go_buildargs[@]}" ./cmd/...
}

src_install() {
	exeinto /usr/bin
	doexe bin/earthly
	newexe bin/debugger earthly-debugger

	einstalldocs
}

pkg_postinst() {
	if has_version "app-containers/podman" ; then
		ewarn "Podman is supported but not recommended."
		ewarn "If issues arise, then please try running earthly with docker."
	fi

	if has_version "app-containers/podman[rootless]" ; then
		ewarn "Running podman in rootless mode is not supported because"
		ewarn "earthly/dind and earthly/buildkit require privileged access."
		ewarn "For more info see: https://docs.earthly.dev/docs/guides/podman/"
	fi
}
