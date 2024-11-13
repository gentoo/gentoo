# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
PYTHON_REQ_USE="ncurses"

inherit distutils-r1

DESCRIPTION="2-way/3-way merge tool (CLI, Ncurses)"
HOMEPAGE="https://github.com/osamuaoki/imediff"
SRC_URI="https://github.com/osamuaoki/${PN}/archive/upstream/${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN}-upstream-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

distutils_enable_tests unittest

src_install() {
	distutils-r1_src_install
	rm "${ED}"/usr/bin/imediff_install || die
	python_doscript "${ED}"/usr/bin/imediff
	newbin usr/bin/git-ime.in git-ime
	doman usr/share/man/man1/imediff.1 usr/share/man/man1/git-ime.1
}
