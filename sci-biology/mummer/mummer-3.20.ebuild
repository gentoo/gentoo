# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

MY_P="MUMmer${PV}"
DESCRIPTION="A rapid whole genome aligner"
HOMEPAGE="http://mummer.sourceforge.net/"
SRC_URI="mirror://sourceforge/mummer/${MY_P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
IUSE="doc"
KEYWORDS="amd64 x86"

DEPEND=""
RDEPEND="app-shells/tcsh"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-gcc43.patch
	# Warning: package uses CPPFLAGS on c in addition to cpp, despite the name
	sed -i -e 's/CPPFLAGS =/CPPFLAGS = ${CFLAGS} /' \
		-e 's/LDFLAGS  =$//' "${S}/Makefile"
}

src_compile() {
	emake || die "emake failed"

	sed -i -e 's|\($AUX_BIN_DIR = "\).*"|\1/usr/bin"|' \
		-e 's|\($BIN_DIR = "\).*"|\1/usr/bin"|' \
		-e 's|\($SCRIPT_DIR = "\).*"|\1/usr/share/'${PN}'/lib"|' \
		-e 's|\(set bindir = \).*|\1/usr/bin|' \
		-e 's|\(set scriptdir = \).*|\1/usr/share/'${PN}'/scripts|' \
		-e 's|\(use lib "\).*"|\1/usr/share/'${PN}'/lib"|' \
		scripts/* exact-tandems mapview mummerplot nucmer promer run-mummer{1,3} || die "Failed to replace paths"
	sed -i 's|$bindir/annotate|$bindir/mummer-annotate|' run-mummer1 scripts/run-mummer1.csh
}

src_install() {
	dobin nucmer2xfig show-coords mapview show-snps run-mummer{1,3} \
		exact-tandems promer repeat-match show-aligns gaps mummer \
		show-tiling mgaps nucmer mummerplot delta-filter combineMUMs aux_bin/* || die
	newbin annotate mummer-annotate || die

	insinto /usr/share/${PN}/scripts
	doins scripts/{*.awk,*.csh,*.pl}
	insinto /usr/share/${PN}/lib
	doins scripts/Foundation.pm || die

	dodoc ACKNOWLEDGEMENTS ChangeLog README
	insinto /usr/share/doc/${PF}
	use doc && doins -r docs
}
