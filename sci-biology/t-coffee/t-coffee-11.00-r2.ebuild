# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

MY_HASH="4466924"
MY_PV="${PV}.${MY_HASH}"
MY_P="${PN^^}_distribution_Version_${MY_PV}"

DESCRIPTION="A multiple sequence alignment package"
HOMEPAGE="http://www.tcoffee.org/Projects_home_page/t_coffee_home_page.html"
SRC_URI="http://www.tcoffee.org/Packages/Beta/Latest/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	sci-biology/clustalw
	sci-chemistry/tm-align"
DEPEND=""

S="${WORKDIR}/${MY_P}"
PATCHES=(
	"${FILESDIR}"/${P}-mayhem.patch
	"${FILESDIR}"/${P}-set_proper_dir_permissions.patch
	"${FILESDIR}"/${P}-cxx11.patch
	"${FILESDIR}"/${P}-gcc7.patch
)

src_prepare() {
	default
	sed \
		-e '/@/s:.*;:\t:g' \
		-e '/Linking/s:$(CC):$(CC) $(CFLAGS) $(LDFLAGS):g' \
		-i t_coffee_source/makefile || die
}

src_compile() {
	emake \
		V=1 \
		CC="$(tc-getCXX)" \
		CFLAGS="${CXXFLAGS} -Wno-write-strings -Wno-unused-result" \
		-C t_coffee_source t_coffee
}

src_install() {
	dobin t_coffee_source/t_coffee

	insinto /usr/share/${PN}
	doins -r example
}
