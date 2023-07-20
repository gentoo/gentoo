# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Test for best practices around deploying docker containers"
HOMEPAGE="https://github.com/docker/docker-bench-security"
SRC_URI="https://github.com/docker/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=app-containers/docker-1.10"

src_unpack() {
	default
	# Gentoo is not a listed as compatible distribution
	rm -r distros
}

src_install() {
	dobin "${FILESDIR}/docker-bench-security"
	exeinto /usr/lib/${PN}
	doexe ${PN}.sh
	insinto /usr/lib/${PN}
	doins -r functions tests MAINTAINERS
	dodoc CONTRIBUTING.md README.md
}
