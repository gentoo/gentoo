# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MIRA_3RDPARTY_PV="06-07-2012"
MY_PV="${PV/_}" # convert from mira-4.0_rc2 (Gentoo ebuild filename derived) to mira-4.0rc2 (upstream fromat)

inherit autotools eutils multilib

DESCRIPTION="Whole Genome Shotgun and EST Sequence Assembler for Sanger, 454 and Solexa / Illumina"
HOMEPAGE="http://www.chevreux.org/projects_mira.html"
SRC_URI="
	http://sourceforge.net/projects/mira-assembler/files/MIRA/stable/"${PN}"-"${MY_PV}".tar.bz2
	mirror://sourceforge/mira-assembler/mira_3rdparty_${MIRA_3RDPARTY_PV}.tar.bz2"
#	http://sourceforge.net/projects/mira-assembler/files/MIRA/development/${P}.tar.bz2
#	mirror://sourceforge/mira-assembler/mira_3rdparty_${MIRA_3RDPARTY_PV}.tar.bz2"

S="${WORKDIR}"/"${PN}"-"${MY_PV}"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="doc"

CDEPEND="
	dev-libs/boost
	dev-util/google-perftools"
DEPEND="${CDEPEND}
	app-editors/vim-core
	dev-libs/expat"
RDEPEND="${CDEPEND}"

#DOCS=( AUTHORS GETTING_STARTED NEWS README HELP_WANTED
#	THANKS doc/3rdparty/scaffolding_MIRA_BAMBUS.pdf )
DOCS=( AUTHORS GETTING_STARTED NEWS README HELP_WANTED THANKS )

src_prepare() {
	find -name 'configure*' -or -name 'Makefile*' | xargs sed -i 's/flex++/flex -+/' || die
	epatch \
		"${FILESDIR}"/${PN}-3.4.0.2-boost-1.50.patch \
		"${FILESDIR}"/${P}-cout.patch

	sed \
		-e "s:-O[23]::g" \
		-e "s:-funroll-loops::g" \
		-i configure.ac || die

	eautoreconf
}

src_configure() {
	econf \
		--with-boost="${EPREFIX}/usr/$(get_libdir)" \
		--with-boost-libdir="${EPREFIX}/usr/$(get_libdir)" \
		--with-boost-thread=boost_thread-mt
}

#src_compile() {
#	base_src_compile
#	# TODO: resolve docbook incompatibility for building docs
#	if use doc; then emake -C doc clean docs || die; fi
#}

src_install() {
	default
	dodoc ${DOCS[@]}

	dobin "${WORKDIR}"/3rdparty/{sff_extract,qual2ball,*.pl}
	dodoc "${WORKDIR}"/3rdparty/{README.txt,midi_screen.fasta}
}

pkg_postinst() {
	einfo "Documentation is no longer built, you can find it at:"
	einfo "http://mira-assembler.sourceforge.net/docs/DefinitiveGuideToMIRA.html"
}
