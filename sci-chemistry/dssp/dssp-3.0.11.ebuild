# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit autotools

MY_PN="hssp"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="The protein secondary structure standard"
HOMEPAGE="https://swift.cmbi.umcn.nl/gv/dssp/ https://github.com/cmbi/hssp"
SRC_URI="https://github.com/cmbi/${MY_PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
# It's just cppcheck (at least in 3.0.11)
RESTRICT="test"

RDEPEND="
	dev-lang/perl:=
	dev-libs/boost:=[bzip2,zlib,threads(+)]
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default

	# Fix version
	sed -i -e "s/3.0.10/${PV}/" configure.ac || die

	sed -i -e '/-Werror/d' Makefile.am || die

	eautoreconf
}

src_install() {
	default
	dosym mkdssp /usr/bin/dssp
	doenvd "${FILESDIR}"/30-${PN}
}
