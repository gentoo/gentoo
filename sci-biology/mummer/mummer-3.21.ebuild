# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="A rapid whole genome aligner"
HOMEPAGE="http://mummer.sourceforge.net/"
SRC_URI="mirror://sourceforge/mummer/MUMmer${PV}.tar.gz"

LICENSE="Artistic"
SLOT="0"
IUSE="doc"
KEYWORDS="amd64 x86"

DEPEND=""
RDEPEND="app-shells/tcsh"

S="${WORKDIR}/MUMmer${PV}"

src_unpack() {
	unpack ${A}
	# Warning: package uses CPPFLAGS on c as well as cpp, despite the name
	sed -i -e 's/CPPFLAGS =/CPPFLAGS = ${CFLAGS} /' \
		-e 's/LDFLAGS  =$//' "${S}/Makefile" || die
}

src_compile() {
	emake || die

	sed -i -e 's|\($AUX_BIN_DIR = "\).*"|\1/usr/bin"|' \
		-e 's|\($BIN_DIR = "\).*"|\1/usr/bin"|' \
		-e 's|\($SCRIPT_DIR = "\).*"|\1/usr/share/'${PN}'/lib"|' \
		-e 's|\(set bindir = \).*|\1/usr/bin|' \
		-e 's|\(set scriptdir = \).*|\1/usr/share/'${PN}'/scripts|' \
		-e 's|\(use lib "\).*"|\1/usr/share/'${PN}'/lib"|' \
		scripts/* exact-tandems mapview mummerplot nucmer promer run-mummer{1,3} || die
	mv annotate mummer-annotate || die
	sed -i 's|$bindir/annotate|$bindir/mummer-annotate|' run-mummer1 scripts/run-mummer1.csh || die
}

src_install() {
	dobin $(find . -maxdepth 1 -type f -executable) aux_bin/* || die

	insinto /usr/share/${PN}/scripts
	doins scripts/{*.awk,*.csh,*.pl} || die
	insinto /usr/share/${PN}/lib
	doins scripts/Foundation.pm || die

	dodoc ACKNOWLEDGEMENTS ChangeLog README
	insinto /usr/share/doc/${PF}
	use doc && doins -r docs
}
