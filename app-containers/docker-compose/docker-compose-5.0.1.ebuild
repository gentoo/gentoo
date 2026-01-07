# Copyright 2018-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit eapi9-ver go-module
MY_PV=${PV/_/-}

DESCRIPTION="Multi-container orchestration for Docker"
HOMEPAGE="https://github.com/docker/compose"
SRC_URI="https://github.com/docker/compose/archive/v${MY_PV}.tar.gz -> ${P}.gh.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

S="${WORKDIR}/compose-${MY_PV}"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~amd64 ~arm64"

RDEPEND="|| (
	>=app-containers/docker-cli-23.0.0
	app-containers/podman[wrapper(+)]
)"
BDEPEND=">=dev-lang/go-1.24.7"

RESTRICT="test"

src_compile() {
	emake VERSION=v${PV}
}

src_test() {
	emake test
}

src_install() {
	exeinto /usr/libexec/docker/cli-plugins
	doexe bin/build/docker-compose
	dodoc README.md
}

pkg_postinst() {
	if ver_replacing -lt 2; then
		ewarn
		ewarn "docker-compose 2.x is a sub command of docker"
		ewarn "Use 'docker compose' from the command line instead of"
		ewarn "'docker-compose'"
		ewarn "If you need to keep 1.x around, please run the following"
		ewarn "command before your next --depclean"
		ewarn "# emerge --noreplace docker-compose:0"
	fi
}
