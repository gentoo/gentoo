# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CMAKE_MAKEFILE_GENERATOR="ninja"

inherit cmake-utils

IUSE=""
DEPEND="=sci-chemistry/csg-${PV} )"
if [ "${PV}" != "9999" ]; then
	SRC_URI="https://github.com/${PN/-//}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-macos"
	S="${WORKDIR}/${P#votca-}"
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN/-//}.git"
	KEYWORDS=""
fi

DESCRIPTION="Manual for votca-csg"
HOMEPAGE="http://www.votca.org"

LICENSE="Apache-2.0"
SLOT="0"

RDEPEND=""

DEPEND="
	app-doc/doxygen[dot]
	dev-texlive/texlive-latexextra
	virtual/latex-base
	dev-tex/pgf
	>=app-text/txt2tags-2.5
	~sci-chemistry/votca-csg-${PV}"
