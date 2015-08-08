# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="A genome sequence finishing program"
HOMEPAGE="http://bozeman.mbt.washington.edu/consed/consed.html"
SRC_URI="
	${P}-sources.tar.gz
	${P}-linux.tar.gz"

LICENSE="phrap"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=x11-libs/motif-2.3:0"
RDEPEND="${DEPEND}
	sci-biology/samtools
	>=sci-biology/phred-000925
	>=sci-biology/phrap-1.080721
	dev-lang/perl"

S="${WORKDIR}"

RESTRICT="fetch"

pkg_nofetch() {
	einfo "Please visit ${HOMEPAGE} and obtain the file"
	einfo "\"sources.tar.gz\", then rename it to \"${P}-sources.tar.gz\""
	einfo "and place it in ${DISTDIR},"
	einfo "obtain the file"
	einfo "\"consed_linux.tar.gz\", then rename it to \"${P}-linux.tar.gz\""
	einfo "and place it in ${DISTDIR}"
}

src_prepare() {
	sed -i '/#include/ s/<new.h>/<new>/' "${S}/main.cpp" || die
	sed -i \
		-e '/CLIBS=/ s/$/ -lXm -lXt -lSM -lICE -lXext -lXmu -lXp -lm -lbam -lz/' \
		-e 's/ARCHIVES=/ARCHIVES=\n_ARCHIVES=/' \
		-e 's/CFLGS=/CFLGS= ${CFLAGS} /' \
		-e 's#/me1/gordon/samtools/samtools-0.1.18#/usr/include/bam/#' "${S}/makefile" || die
	sed -i -e 's/CFLAGS=/CFLAGS += /' "${S}"/misc/*/Makefile || die
	sed \
		-e 's!\($szPhredParameterFile =\).*!\1 $ENV{PHRED_PARAMETER_FILE} || "'${EPREFIX}'/usr/share/phred/phredpar.dat";!' \
		-i "${S}"/scripts/* || die
}

src_compile() {
	emake
	emake -C misc/mktrace
	emake -C misc/phd2fasta
	(cd misc/454; $(tc-getCC) ${CFLAGS} ${LDFLAGS} sff2scf.c -o sff2scf) || die
}

src_install() {
	dobin consed misc/{mktrace/mktrace,phd2fasta/phd2fasta,454/sff2scf}
	dobin scripts/* contributions/*
	insinto /usr/lib/screenLibs
	doins misc/*.{fa*,seq}
	insinto /usr/share/${PN}/examples
	doins -r \
		standard polyphred autofinish assembly_view 454_newbler \
		align454reads align454reads_answer solexa_example \
		solexa_example_answer selectRegions selectRegionsAnswer
	echo 'CONSED_HOME="${EPREFIX}/usr"' > "${S}"/99consed || die
	echo 'CONSED_PARAMETERS="${EPREFIX}/etc/consedrc"' >> "${S}"/99consed || die
	mkdir -p "${ED}"/etc/consedrc || die
	touch "${ED}"/etc/consedrc || die
	doenvd "${S}/99consed" || die
	sed \
		-e "s#/usr/local/genome#${EPREFIX}/usr#" \
		-i "${ED}"/usr/bin/{*.perl,phredPhrap,phredPhrapWithPhdBalls} || die
	sed \
		-e 's#niceExe = "/bin/nice"#niceExe = "/usr/bin/nice"#' \
		-i "${ED}"/usr/bin/phredPhrap || die
	sed \
		-e 's#/wt1/gordon/genome#/usr/bin#' \
		-i "${ED}"/usr/bin/fastq2Phrap.perl || die
	dodoc README.txt *_announcement.txt || die
}

pkg_postinst() {
	einfo "Package documentation is available at"
	einfo "http://www.phrap.org/consed/distributions/README.${PV}.0.txt"
}
