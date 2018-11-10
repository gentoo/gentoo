# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="A suite of algorithms to help factoring large integers"
# inactive old homepage exists, this is a fork
HOMEPAGE="https://github.com/radii/ggnfs"
# snapshot because github makes people stupid
SRC_URI="
	http://dev.gentooexperimental.org/~dreeevil/${P}.zip
	http://stuff.mit.edu/afs/sipb/project/pari-gp/ggnfs/Linux/src/def-par.txt
	http://stuff.mit.edu/afs/sipb/project/pari-gp/ggnfs/Linux/src/def-nm-params.txt
	http://gentooexperimental.org/~patrick/ggnfs-doc.pdf"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-libs/gmp-4.3:0
	app-arch/unzip"
RDEPEND="${DEPEND}
	!sci-mathematics/cado-nfs" # file collisions, fixable

S=${WORKDIR}/${PN}-master

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
	echo "#define GGNFS_VERSION \"0.77.1-$ARCH\"" > include/version.h || die
	# fix directory symlink, add missing targets, rewrite variable used by portage internally
	cd src/lasieve4 && rm -f -r asm && ln -s ppc32 asm || die
	sed -i -e 's/all: liblasieve.a/all: liblasieve.a liblasieveI11.a liblasieveI15.a liblasieveI16.a/' asm/Makefile || die
	cd "${S}"
	sed -i -e 's/ARCH/MARCH/g' Makefile src/Makefile || die
	sed -i -e 's/$(LSBINS) strip/$(LSBINS)/' src/Makefile || die #No stripping!
	sed -i -e 's/SVN \$Revision\$/0.77.1 snapshot/' src/experimental/lasieve4_64/gnfs-lasieve4e.c src/lasieve4/gnfs-lasieve4e.c || die
	tc-export CC
}

src_configure() { :; }

src_compile() {
	# setting MARCH like this is fugly, but it uses -march=$ARCH - better fix welcome
	# it also assumes a recent-ish compiler
	cd src
	HOST="generic" MARCH="${ARCH}" emake -j1
}

src_install() {
	mkdir -p "${D}/usr/bin/"
	for i in gnfs-lasieve4I11e gnfs-lasieve4I12e gnfs-lasieve4I13e gnfs-lasieve4I14e \
		gnfs-lasieve4I15e gnfs-lasieve4I16e makefb matbuild matprune matsolve pol51m0b pol51m0n \
		pol51opt polyselect procrels sieve sqrt; do
		cp "${S}/bin/${i}" "${D}/usr/bin/" || die
	done
	mkdir -p "${D}/usr/share/doc/${PN}"
	cp "${DISTDIR}/def-par.txt" "${D}/usr/share/doc/${PN}" || die
	cp "${DISTDIR}/def-nm-params.txt" "${D}/usr/share/doc/${PN}" || die
	docompress -x "/usr/share/doc/${PN}/def-par.txt"
	docompress -x "/usr/share/doc/${PN}/def-nm-params.txt"
	# TODO: docs? File collisions?
	cp ${DISTDIR}/ggnfs-doc.pdf "${D}/usr/share/doc/${PN}" || die
}
