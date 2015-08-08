# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils flag-o-matic toolchain-funcs

MY_HASH="8cbe486"
MY_PV="${PV}.${MY_HASH}"
MY_P="T-COFFEE_distribution_Version_${MY_PV}"

DESCRIPTION="A multiple sequence alignment package"
HOMEPAGE="http://www.tcoffee.org/Projects_home_page/t_coffee_home_page.html"
SRC_URI="http://www.tcoffee.org/Packages/Stable/Version_${MY_PV}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples"

RDEPEND="
	sci-biology/clustalw
	sci-chemistry/tm-align"
DEPEND=""

S="${WORKDIR}/${MY_P}"

src_prepare() {
	sed \
		-e '/@/s:.*;:\t:g' \
		-e '/Linking/s:$(CC):$(CC) $(CFLAGS) $(LDFLAGS):g' \
		-i t_coffee_source/makefile || die
}

src_compile() {
	[[ $(gcc-version) == "3.4" ]] || \
		[[ $(gcc-version) == "4.1" ]] && \
		append-flags -fno-unit-at-a-time
	emake \
		V=1 \
		CC="$(tc-getCXX)" \
		CFLAGS="${CXXFLAGS} -Wno-write-strings -Wno-unused-result" \
		-C t_coffee_source t_coffee
}

src_install() {
	dobin t_coffee_source/t_coffee

	if use examples; then
		insinto /usr/share/${PN}
		doins -r example
	fi
}
