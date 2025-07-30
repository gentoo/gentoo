# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
	scm_eclass=git-r3
else
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~ppc-macos ~x64-macos ~x64-solaris"
	SRC_URI="https://github.com/${PN}/${PN}/archive/${P}.tar.gz"
	S=${WORKDIR}/${PN}-${P}
fi

PYTHON_COMPAT=( python3_{9..12} )

inherit cmake python-any-r1 ${scm_eclass}

DESCRIPTION="C/C++/C#/D/Java/Pawn code indenter and beautifier"
HOMEPAGE="https://uncrustify.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"

BDEPEND="${PYTHON_DEPS}"

src_configure() {
	local mycmakeargs=(
		-DPython3_FIND_STRATEGY=LOCATION
	)

	cmake_src_configure
}
