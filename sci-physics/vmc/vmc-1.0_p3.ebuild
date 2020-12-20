# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

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

DESCRIPTION="The Virtual Monte Carlo core library."
HOMEPAGE="https://vmc-project.github.io/"

LICENSE="GPL-3"
SLOT="0"
IUSE="+c++11 c++14 c++17 doc"

REQUIRED_USE="^^ ( c++11 c++14 c++17 )"

RDEPEND=">=sci-physics/root-6.18:=[c++11?,c++14?,c++17?,-vmc]"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen[dot] )"

DOCS=(README.md History)

src_compile() {
	cmake_src_compile
	if use doc; then
		# TRAVIS_BUILD_DIR hardcoded in Doxyfile by upstream.
		TRAVIS_BUILD_DIR="${S}" doxygen doc/doxygen/Doxyfile || die
	fi
}

src_install() {
	cmake_src_install
	use doc && local HTML_DOCS=( doc/html/. )
	einstalldocs
}
