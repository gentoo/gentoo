# Copyright 2018-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit eapi9-ver optfeature

DESCRIPTION="Multi-container orchestration for Docker"
HOMEPAGE="https://github.com/docker/compose"
SRC_URI="https://github.com/docker/compose/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
SRC_URI+=" https://github.com/gentoo-golang-dist/compose/releases/download/v${PV}/compose-${PV}-vendor.tar.xz"
S="${WORKDIR}/compose-${PV}"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="amd64 arm64"
RESTRICT="test"

RDEPEND="
	|| (
		>=app-containers/docker-cli-29.5.2
		app-containers/podman[wrapper(+)]
	)
"
BDEPEND=">=dev-lang/go-1.25.5"

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
	optfeature "credential store support" app-containers/docker-credential-helpers

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
