# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOCS_BUILDER="doxygen"
DOCS_DEPEND="app-text/doxygen[dot]"
# Not setting DOCS_PATH as upstream expects doxygen to run in ${S}
DOCS_CONFIG_NAME="doc/doxygen/Doxyfile"

inherit cmake docs

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/vmc-project/${PN}.git"
else
	MY_PV=$(ver_rs 1-2 -)
	SRC_URI="https://github.com/vmc-project/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

DESCRIPTION="The Virtual Monte Carlo core library"
HOMEPAGE="
	https://vmc-project.github.io/
	https://github.com/vmc-project/vmc
"

LICENSE="GPL-3"
SLOT="0"
IUSE="doc"

RDEPEND="sci-physics/root:="
DEPEND="${RDEPEND}"

DOCS=( README.md History )

src_compile() {
	cmake_src_compile
	docs_compile
}

src_install() {
	cmake_src_install
	einstalldocs
}
