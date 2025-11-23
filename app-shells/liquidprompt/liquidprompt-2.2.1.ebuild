# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Full-featured & carefully designed adaptive prompt for Bash & Zsh"
HOMEPAGE="https://github.com/nojhan/liquidprompt https://liquidprompt.readthedocs.io/"
SRC_URI="
	https://github.com/nojhan/liquidprompt/releases/download/v${PV}/${PN}-v${PV}.tar.gz
		-> ${P}.tar.gz
	test? (
		https://raw.githubusercontent.com/rcaloras/bash-preexec/0.4.1/bash-preexec.sh
	)
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
	cp "${DISTDIR}/bash-preexec.sh" tests/ || die
	cp "$(type -P shunit2)" tests/shunit2 || die
	./tests.sh bash || die
}

src_install() {
	default
	dobin liquidprompt

	insinto /usr/share/${PN}
	doins -r themes templates tools

	insinto /etc/
	./tools/config-from-doc.sh > "${T}/liquidpromptrc" || die
	newins "${T}/liquidpromptrc" liquidpromptrc
}
