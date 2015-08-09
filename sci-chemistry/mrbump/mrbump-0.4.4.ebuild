# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

PYTHON_DEPEND="2"

inherit eutils multilib python

DESCRIPTION="An automated scheme for Molecular Replacement"
HOMEPAGE="http://www.ccp4.ac.uk/MrBUMP"
SRC_URI="${HOMEPAGE}/release/${P}.tar.gz"

LICENSE="ccp4"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux"
IUSE="X perl"

RDEPEND=">=sci-chemistry/ccp4-apps-6.1.3[X?]
	|| ( sci-biology/mafft
		sci-biology/clustalw:2
		sci-biology/probcons
		sci-biology/t-coffee )
	sci-biology/fasta
	X? ( media-gfx/graphviz )
	perl? ( dev-perl/SOAP-Lite )"
DEPEND="${RDEPEND}"

pkg_setup() {
	python_set_active_version 2
}

src_unpack(){
	unpack ${A}
	cd "${S}"
	unpack ./"${PN}".tar.gz
}

src_prepare() {
	epatch "${FILESDIR}"/${PV}-superpose.patch
	python_convert_shebangs 2 setup_lib/*
}

src_install(){
	insinto /usr/$(get_libdir)/ccp4/ccp4i
	doins -r ccp4i/{MrBUMP-ccp4i.tar.gz,MrBUMP/{help,scripts,tasks,templates}} || \
	die "failed to install interface"

	insinto /usr/share/${PN}
	doins -r share/${PN}/{data,include} || die "failed to install mrbump data"

	dobin share/${PN}/bin/* || die "failed to install binaries"

	dodoc README.txt || die
	dohtml html/mrbump_doc.html || die
}
