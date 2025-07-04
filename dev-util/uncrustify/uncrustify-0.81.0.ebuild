# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
	scm_eclass=git-r3
else
	KEYWORDS="amd64 x86 ~amd64-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
	SRC_URI="https://github.com/${PN}/${PN}/archive/${P}.tar.gz"
	S=${WORKDIR}/${PN}-${P}
fi

PYTHON_COMPAT=( python3_{9..12} )

inherit cmake python-any-r1 ${scm_eclass}

DESCRIPTION="C/C++/C#/D/Java/Pawn code indenter and beautifier"
HOMEPAGE="https://uncrustify.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( ${PYTHON_DEPS} )"

pkg_setup() {
	use test && python-any-r1_pkg_setup
}
