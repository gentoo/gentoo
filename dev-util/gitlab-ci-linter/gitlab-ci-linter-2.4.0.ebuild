# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="linter for .gitlab-ci.yml files"
HOMEPAGE="https://gitlab.com/orobardet/gitlab-ci-linter"
SRC_URI="https://gitlab.com/orobardet/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"
S="${WORKDIR}/${PN}-v${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND=">=dev-lang/go-1.24"

RESTRICT="test"

QA_PRESTRIPPED=usr/bin/gitlab-ci-linter

src_compile() {
	unset LDFLAGS
	emake
}

src_install() {
	dobin .build/gitlab-ci-linter
	dodoc -r CHANGELOG.md doc README.md
}
