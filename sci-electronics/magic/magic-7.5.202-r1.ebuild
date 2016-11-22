# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit multilib eutils autotools

DESCRIPTION="The VLSI design CAD tool"
HOMEPAGE="http://www.opencircuitdesign.com/magic/index.html"
SRC_URI="http://www.opencircuitdesign.com/magic/archive/${P}.tgz \
	ftp://ftp.mosis.edu/pub/sondeen/magic/new/beta/2002a.tar.gz"

LICENSE="HPND GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="sys-libs/ncurses:0=
	sys-libs/readline:0=
	dev-lang/tcl:0=
	dev-lang/tk:0=
	dev-tcltk/blt"
DEPEND="${RDEPEND}
	app-shells/tcsh"

src_prepare() {
	epatch "${FILESDIR}/${PN}-ldflags.patch"
	epatch "${FILESDIR}/${P}-install.patch" #422687
	epatch "${FILESDIR}/${P}-include.patch"
	cd scripts
	eautoreconf
	cd ..
	sed -i -e "s: -pg : :" tcltk/Makefile || die
}

src_configure() {
	# Short-circuit top-level configure script to retain CFLAGS
	# fix tcl/tk detection #447868
	cd scripts
	CPP="cpp" econf --with-tcllibs="/usr/$(get_libdir)" --with-tklibs="/usr/$(get_libdir)"
}

src_compile() {
	emake -j1
}

src_install() {
	emake -j1 DESTDIR="${D}" install

	dodoc README README.Tcl TODO

	# Move docs from libdir to docdir and add symlink.
	mv "${D}/usr/$(get_libdir)/magic/doc"/* "${D}/usr/share/doc/${PF}/" || die
	rmdir "${D}/usr/$(get_libdir)/magic/doc" || die
	dosym "/usr/share/doc/${PF}" "/usr/$(get_libdir)/magic/doc"

	# Move tutorial from libdir to datadir and add symlink.
	dodir /usr/share/${PN}
	mv "${D}/usr/$(get_libdir)/magic/tutorial" "${D}/usr/share/${PN}/" || die
	dosym "/usr/share/${PN}/tutorial" "/usr/$(get_libdir)/magic/tutorial"

	# Install latest MOSIS tech files
	cp -pPR "${WORKDIR}"/2002a "${D}"/usr/$(get_libdir)/magic/sys/current || die
}
