# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs

MY_P=GlimmerHMM

DESCRIPTION="A eukaryotic gene finding system from TIGR"
HOMEPAGE="http://www.cbcb.umd.edu/software/GlimmerHMM/"
SRC_URI="ftp://ftp.cbcb.umd.edu/pub/software/glimmerhmm/${MY_P}-${PV}.tar.gz"

LICENSE="Artistic"
SLOT="0"
IUSE=""
KEYWORDS="amd64 x86"

src_unpack() {
	unpack ${A}
	mv GlimmerHMM ${P}
}

src_prepare() {
	sed \
		-e 's|\(my $scriptdir=\)$FindBin::Bin|\1"/usr/libexec/'${PN}'/training_utils"|' \
		-e 's|\(use lib\) $FindBin::Bin|\1 "/usr/share/'${PN}'/lib"|' \
		-i "${S}/train/trainGlimmerHMM" || die

	epatch "${FILESDIR}"/${PV}-gentoo.patch
	tc-export CC CXX
}

src_compile() {
	emake -C "${S}/sources"
	emake -C "${S}/train"
}

src_install() {
	dobin sources/glimmerhmm train/trainGlimmerHMM

	insinto /usr/share/${PN}/lib
	doins train/*.pm
	insinto /usr/share/${PN}/models
	doins -r trained_dir/*
	exeinto /usr/libexec/${PN}/training_utils
	doexe train/{build{1,2,-icm,-icm-noframe},erfapp,falsecomp,findsites,karlin,score,score{2,ATG,ATG2,STOP,STOP2},splicescore}

	dodoc README.first train/readme.train
}
