# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit autotools

DESCRIPTION="A fast splice junction mapper for RNA-Seq reads"
HOMEPAGE="http://tophat.cbcb.umd.edu/"
SRC_URI="http://tophat.cbcb.umd.edu/downloads/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
IUSE=""
KEYWORDS="amd64 x86"

DEPEND=""
RDEPEND="sci-biology/bowtie"

src_prepare() {
	# fix missing includes
	sed -i '/#include <string>/ a #include <stdio.h>' "${S}/src/gff_juncs.cpp" || die
	sed -i \
		-e '/#include <stdio.h>/ a #include <unistd.h>' \
		"${S}/src/prep_reads.cpp" \
		"${S}/src/extract_reads.cpp" || die
	# fix parallel make race
	sed -i -e 's/\$(top_builddir)\/src\///g' src/Makefile.am || die
	# remove broken arch-dependent CFLAGS setting
	perl -i -ne 'print unless /case "\${host_cpu}-\${host_os}" in/../^esac/' configure.ac || die
	eautoreconf
}

src_install() {
	einstall || die
	dodoc AUTHORS NEWS THANKS
}
