# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Full-featured & carefully designed adaptive prompt for Bash & Zsh"
HOMEPAGE="https://github.com/nojhan/liquidprompt"
SRC_URI="
	https://github.com/nojhan/liquidprompt/releases/download/v${PV}/${PN}-v${PV}.tar.gz
		-> ${P}.tar.gz
"
S="${WORKDIR}/${PN}"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( dev-util/shunit2 )"

DOCS=( CHANGELOG.md example.bashrc README.md )

src_test() {
	cp "$(type -P shunit2)" tests/shunit2 || die
	./tests.sh || die
}

src_install() {
	default
	dobin liquidprompt

	insinto /usr/share/${PN}
	doins liquid.theme
	doins liquid.ps1
	doins -r themes

	insinto /etc/
	newins liquidpromptrc-dist liquidpromptrc
}
