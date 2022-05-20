# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Generate marked up documents (HTML, etc.)from a plain text file with markup"
HOMEPAGE="https://txt2tags.org"
SRC_URI="https://codeload.github.com/txt2tags/txt2tags/tar.gz/${PV} -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris"

python_test() {
	cd test || die
	"${EPYTHON}" run.py || die "Tests failed with ${EPYTHON}"
}
