# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Semi-official Mercurial bridge from Git project"
HOMEPAGE="https://github.com/mnauw/git-remote-hg"
SRC_URI="https://github.com/mnauw/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	app-text/asciidoc
"
RDEPEND="
	dev-vcs/git
	dev-vcs/mercurial
"

# Some tests fail.
RESTRICT="test"

src_compile() {
	distutils-r1_src_compile
	emake doc
}

src_install() {
	distutils-r1_src_install
	emake DESTDIR="${D}" prefix="${EPREFIX}/usr" install-doc
}

src_test() {
	default
}
