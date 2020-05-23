# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="Modern C++ Parallel Task Programming"
HOMEPAGE="https://cpp-taskflow.github.io"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=""
DEPEND=""

PATCHES=(
	"${FILESDIR}"/${P}-do_not_compile_examples.patch
	"${FILESDIR}"/${P}-fix_installation_path.patch
)

HTML_DOCS=( docs/. )

src_install() {
	cmake-utils_src_install

	if $(use doc); then
		einstalldocs
	fi
}
