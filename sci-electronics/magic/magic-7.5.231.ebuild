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
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug opengl"

RDEPEND="sys-libs/ncurses:0=
	sys-libs/readline:0=
	dev-lang/tcl:0=
	dev-lang/tk:0=
	dev-tcltk/blt
	opengl? ( virtual/opengl )"
DEPEND="${RDEPEND}
	app-shells/tcsh"

src_prepare() {
	einfo remove bundled readline-4.3
	rm -r readline || die

	epatch \
		"${FILESDIR}"/${PN}-7.5.231-blt-test.patch \
		"${FILESDIR}"/${PN}-7.5.231-ldflags.patch \
		"${FILESDIR}"/${PN}-7.5.231-verbose-build.patch

	cd scripts || die
	eautoreconf
	cd .. || die

	sed -i -e "s: -pg : :" tcltk/Makefile || die
}

src_configure() {
	# Short-circuit top-level configure script to retain CFLAGS
	# fix tcl/tk detection #447868
	cd scripts
	CPP="cpp" econf \
		--with-tcl=yes \
		--with-tcllibs="/usr/$(get_libdir)" \
		--with-tklibs="/usr/$(get_libdir)" \
		--enable-modular \
		$(use_enable debug memdebug) \
		$(use_with opengl)
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
