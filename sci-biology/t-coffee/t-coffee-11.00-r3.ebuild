# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

MY_HASH="4466924"
MY_PV="${PV}.${MY_HASH}"
MY_P="${PN^^}_distribution_Version_${MY_PV}"

DESCRIPTION="A multiple sequence alignment package"
HOMEPAGE="http://www.tcoffee.org/Projects_home_page/t_coffee_home_page.html"
SRC_URI="http://www.tcoffee.org/Packages/Beta/Latest/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	sci-biology/clustalw
	sci-chemistry/tm-align"

PATCHES=(
	"${FILESDIR}"/${P}-mayhem.patch
	"${FILESDIR}"/${P}-set_proper_dir_permissions.patch
	"${FILESDIR}"/${P}-cxx11.patch
	"${FILESDIR}"/${P}-gcc7.patch
	"${FILESDIR}"/${P}-makefile.patch
)

src_configure() {
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/862327
	# https://github.com/cbcrg/tcoffee/issues/60
	#
	# Do not trust with LTO either
	append-flags -fno-strict-aliasing
	filter-lto

	tc-export CXX
	append-cxxflags -Wno-write-strings -Wno-unused-result
}

src_compile() {
	emake -C t_coffee_source t_coffee
}

src_install() {
	dobin t_coffee_source/t_coffee

	insinto /usr/share/t-coffee
	doins -r example
}
