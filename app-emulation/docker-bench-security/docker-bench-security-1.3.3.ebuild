# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Test for best practices around deploying docker containers"
HOMEPAGE="https://github.com/docker/docker-bench-security"
SRC_URI="https://github.com/docker/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=app-emulation/docker-1.10"

src_install() {
dobin "${FILESDIR}/docker-bench-security"
exeinto /usr/lib/${PN}
doexe ${PN}.sh
insinto /usr/lib/${PN}
doins -r *lib.sh tests
	dodoc -r benchmark_log.png CONTRIBUTING.md distros docker-compose.yml \
		Dockerfile MAINTAINERS README.md
}
