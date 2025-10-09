# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Library to parse and emit YAML, and do it fast"
HOMEPAGE="https://github.com/biojppm/rapidyaml/"
SRC_URI="
	https://github.com/biojppm/rapidyaml/releases/download/v${PV}/${P}-src.tgz
"
S=${WORKDIR}/${P}-src

LICENSE="MIT Boost-1.0 BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"

# tests here are a maintenance headache, and current maintainer does
# not need this package anymore -- please take the package over if you
# want to handle this properly (keeping this in low maintenance mode
# incl. ignoring some features like python bindings)
RESTRICT="test"

DOCS=( README.md ROADMAP.md changelog )

src_prepare() {
	cmake_src_prepare

	sed -E "/set\(_(ARCHIVE|LIBRARY)_INSTALL/s:lib/:$(get_libdir)/:" \
		-i ext/c4core/cmake/c4Project.cmake || die
}
