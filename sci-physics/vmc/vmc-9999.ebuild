# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

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
HOMEPAGE="https://vmc-project.github.io/ https://github.com/vmc-project/vmc"

LICENSE="GPL-3"
SLOT="0"
IUSE="doc"

RDEPEND="sci-physics/root:="
DEPEND="${RDEPEND}"
BDEPEND="doc? ( app-doc/doxygen[dot] )"

DOCS=(README.md History)

src_compile() {
	cmake_src_compile
	if use doc; then
		doxygen doc/doxygen/Doxyfile || die
	fi
}

src_install() {
	cmake_src_install
	use doc && local HTML_DOCS=( doc/html/. )
	einstalldocs
}
