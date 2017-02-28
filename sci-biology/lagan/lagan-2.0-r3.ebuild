# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

MY_P="lagan20"

DESCRIPTION="The LAGAN suite of tools for whole-genome multiple alignment of genomic DNA"
HOMEPAGE="http://lagan.stanford.edu/lagan_web/index.shtml"
SRC_URI="http://lagan.stanford.edu/lagan_web/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-lang/perl"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/${PN}-2.0-flags.patch"
	"${FILESDIR}/${PN}-2.0-gcc4.3.patch"
	"${FILESDIR}/${PN}-2.0-fix-c++14.patch"
	"${FILESDIR}/${PN}-2.0-qa-implicit-declarations.patch"
)

src_prepare() {
	sed -i "/use Getopt::Long;/ i use lib \"/usr/$(get_libdir)/${PN}/lib\";" "${S}/supermap.pl" || die
	# NB: Testing with glibc-2.10 has uncovered a bug in src/utils/Sequence.h
	# where libc getline is erroneously used instead of own getline
	sed -i 's/getline/my_getline/' "${S}"/src/{anchors.c,glocal/io.cpp} || die

	default
}

src_compile() {
	emake \
		CC=$(tc-getCC) \
		CXX=$(tc-getCXX) \
		CXXFLAGS="${CXXFLAGS}" \
		CFLAGS="${CFLAGS}"
}

src_install() {
	newbin lagan.pl lagan
	newbin slagan.pl slagan
	dobin mlagan
	rm -f lagan.pl slagan.pl utils/Utils.pm || die

	insinto /usr/$(get_libdir)/${PN}/lib
	doins Utils.pm

	exeinto /usr/$(get_libdir)/${PN}/utils
	doexe utils/*

	exeinto /usr/$(get_libdir)/${PN}
	doexe *.pl anchors chaos glocal order prolagan

	insinto /usr/$(get_libdir)/${PN}
	doins *.txt

	dosym /usr/$(get_libdir)/${PN}/supermap.pl /usr/bin/supermap

	echo "LAGAN_DIR=\"/usr/$(get_libdir)/${PN}\"" > 99${PN} || die
	doenvd 99${PN}

	dodoc Readmes/README.*
}
