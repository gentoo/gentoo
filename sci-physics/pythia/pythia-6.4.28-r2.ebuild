# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools fortran-2

MV=$(ver_cut 1)
MY_PN=${PN}${MV}
DOC_PV=0613
EX_PV=6.4.18
PYR_P=pythia6-20160413

DESCRIPTION="Lund Monte Carlo high-energy physics event generator"
HOMEPAGE="http://pythia6.hepforge.org/"

# pythia6 from root is needed for some files to interface pythia6 with root.
# To produce a split version, replace the 6.4.x by the current version:
# svn export http://svn.hepforge.org/pythia6/tags/v_6_4_x/ pythia-6.4.x
# tar cJf pythia-6.4.x.tar.xz
SRC_URI="
	https://dev.gentoo.org/~bicatali/distfiles/${P}.tar.xz
	https://root.cern.ch/download/pythia6.tar.gz -> ${PYR_P}.tar.gz
	doc? ( http://home.thep.lu.se/~torbjorn/pythia/lutp${DOC_PV}man2.pdf )
	examples? ( mirror://gentoo/${PN}-${EX_PV}-examples.tar.bz2 )"

SLOT="6"
LICENSE="public-domain"
KEYWORDS="~amd64 x86 ~amd64-linux ~x86-linux"
IUSE="doc examples"

PATCHES=( "${FILESDIR}"/${P}-fno-common.patch )

src_prepare() {
	cp ../pythia6/tpythia6_called_from_cc.F .
	cp ../pythia6/pythia6_common_address.c .
	default

	cat > configure.ac <<-EOF || die
		AC_INIT(${PN},${PV})
		AM_INIT_AUTOMAKE
		AC_PROG_F77
		LT_INIT
		AC_CHECK_LIB(m,sqrt)
		AC_CONFIG_FILES(Makefile)
		AC_OUTPUT
	EOF
	echo >> Makefile.am "lib_LTLIBRARIES = libpythia6.la" || die
	echo >> Makefile.am "libpythia6_la_SOURCES = \ " || die
	# replace wildcard from makefile to ls in shell
	local f
	for f in py*.f struct*.f up*.f fh*.f; do
		echo  >> Makefile.am "  ${f} \\" || die
	done
	echo  >> Makefile.am "  ssmssm.f sugra.f visaje.f pdfset.f \\" || die
	echo  >> Makefile.am "  tpythia6_called_from_cc.F pythia6_common_address.c" || die

	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	default
	dodoc update_notes.txt
	use doc && dodoc "${DISTDIR}"/lutp${DOC_PV}man2.pdf
	if use examples; then
		dodoc -r "${WORKDIR}"/examples
		docompress -x /usr/share/doc/${PF}/examples
	fi

	find "${ED}" -name '*.la' -delete || die
}
