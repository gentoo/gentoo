# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Clean all old container revisions from registry"
HOMEPAGE="https://gitlab.com/gitlab-org/docker-distribution-pruner"
SRC_URI="https://gitlab.com/gitlab-org/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.bz2
	https://dev.gentoo.org/~arthurzam/distfiles/${CATEGORY}/${PN}/${P}-deps.tar.xz"
S=${WORKDIR}/${PN}-v${PV}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RESTRICT="test" # no tests

src_compile() {
	ego build -o ${PN} ./cmds/docker-distribution-pruner
}

src_install() {
	dobin ${PN}
}
