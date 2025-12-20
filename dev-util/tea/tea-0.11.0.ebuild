# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 go-module

DESCRIPTION="Command line tool to interact with Gitea server"
HOMEPAGE="https://gitea.com/gitea/tea/"
SRC_URI="
	https://gitea.com/gitea/tea/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
	https://dev.gentoo.org/~xgqt/distfiles/deps/${P}-deps.tar.xz
"
S="${WORKDIR}/tea"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"

DOCS=( CHANGELOG.md README.md )

src_compile() {
	ego build
}

src_test() {
	ego test
}

src_install() {
	exeinto /usr/bin
	doexe tea
	newbashcomp ./contrib/autocomplete.sh tea

	einstalldocs
}
