# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module

DESCRIPTION="linter for .gitlab-ci.yml files"
HOMEPAGE="https://gitlab.com/orobardet/gitlab-ci-linter"
SRC_URI="https://gitlab.com/orobardet/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

S="${WORKDIR}/${PN}-v${PV}"

PATCHES=(
	"${FILESDIR}"/${PN}-no-strip.patch
)

src_compile() {
	unset LDFLAGS
	emake
}

src_install() {
	dobin .build/gitlab-ci-linter
	dodoc -r CHANGELOG.md doc README.md
}
