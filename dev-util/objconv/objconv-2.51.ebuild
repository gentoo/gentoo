# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs unpacker

DESCRIPTION="object code file converted (COFF, ELF, OMF, MACHO)"
HOMEPAGE="http://agner.org/optimize/#objconv"
# original URL is "http://agner.org/optimize/objconv.zip", but it's unversioned.
# I copy those to distfiles time to time. last modified: 2018-Oct-07
SRC_URI="https://dev.gentoo.org/~slyfox/distfiles/${P}.zip"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=""
DEPEND=""
BDEPEND="app-arch/unzip"

S=${WORKDIR}/${P}

src_unpack() {
	unpacker_src_unpack
	mkdir "${S}" || die
	pushd "${S}" || die
	unpack_zip ../source.zip
}

src_prepare() {
	default

	# project has extremenly poor build system (see build.sh)
	local sources=$(echo *.cpp)

	{
		echo "objconv: ${sources//.cpp/.o}"
		echo "	\$(CXX) \$(CXXFLAGS) -o \$@ \$^ \$(LDFLAGS)"
	} > Makefile || die

	tc-export CXX
}

src_install() {
	dobin objconv
	dodoc ../objconv-instructions.pdf
}
