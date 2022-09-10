# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_COMMIT="9e8c3df573015a26c84e113ba710ef3d57c8e777"

DESCRIPTION="Multi-purpose finite-state toolkit"
HOMEPAGE="https://fomafst.github.io/ https://github.com/mhulden/foma"
SRC_URI="https://github.com/mhulden/foma/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/0.10"
KEYWORDS="amd64 x86"

BDEPEND="sys-devel/bison
	sys-devel/flex"
DEPEND="sys-libs/readline:=
	sys-libs/zlib"
RDEPEND="${DEPEND}"

S="${WORKDIR}/foma-${MY_COMMIT}/foma"

src_install() {
	cmake_src_install
	find "${D}" -name '*.a' -delete || die
}
