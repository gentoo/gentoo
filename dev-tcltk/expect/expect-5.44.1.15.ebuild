# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/expect/expect-5.44.1.15.ebuild,v 1.18 2015/03/20 10:22:30 jlec Exp $

EAPI="3"

inherit autotools eutils

DESCRIPTION="tool for automating interactive applications"
HOMEPAGE="http://expect.nist.gov/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-macos ~x86-solaris"
IUSE="debug doc threads X"

# We need dejagnu for src_test, but dejagnu needs expect
# to compile/run, so we cant add dejagnu to DEPEND :/
DEPEND=">=dev-lang/tcl-8.2:0[threads?]
	X? ( >=dev-lang/tk-8.2:0[threads?] )"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i "s#/usr/local/bin#${EPREFIX}/usr/bin#" expect{,k}.man || die
	# stops any example scripts being installed by default
	sed -i \
		-e 's/^SCRIPT_LIST/_&/' \
		-e 's/^SCRIPTS/_&/' \
		-e 's/^SCRIPTS_MANPAGES = /_&/' \
		Makefile.in

	epatch "${FILESDIR}"/${P}-gfbsd.patch
	epatch "${FILESDIR}"/${P}-ldflags.patch
	epatch "${FILESDIR}"/${P}_with-tk-no.patch
	epatch "${FILESDIR}"/${P}-headers.patch #337943
	epatch "${FILESDIR}"/${P}-expectk.patch
	sed -i 's:ifdef HAVE_SYS_WAIT_H:ifndef NO_SYS_WAIT_H:' *.c

	eautoconf
}

src_configure() {
	local myconf
	local tclv
	local tkv
	# Find the version of tcl/tk that has headers installed.
	# This will be the most recently merged, not necessarily the highest
	# version number.
	tclv=$(grep TCL_VER ${EPREFIX}/usr/include/tcl.h | sed 's/^.*"\(.*\)".*/\1/')
	#tkv isn't really needed, included for symmetry and the future
	#tkv=$(grep	 TK_VER ${EPREFIX}/usr/include/tk.h  | sed 's/^.*"\(.*\)".*/\1/')
	myconf="--with-tcl=${EPREFIX}/usr/$(get_libdir) --with-tclinclude=${EPREFIX}/usr/$(get_libdir)/tcl${tclv}/include/generic --with-tk=yes"

	if use X ; then
		#--with-x is enabled by default
		#configure needs to find the file tkConfig.sh and tk.h
		#tk.h is in /usr/lib so don't need to explicitly set --with-tkinclude
		myconf="$myconf --with-tk=${EPREFIX}/usr/$(get_libdir) --with-tkinclude=${EPREFIX}/usr/include"
	else
		#configure knows that tk depends on X so just disable X
		myconf="$myconf --with-tk=no"
	fi

	econf \
		$myconf \
		--enable-shared \
		$(use_enable threads) \
		$(use_enable amd64 64bit) \
		$(use_enable debug symbols)
}

src_test() {
	# we need dejagnu to do tests ... but dejagnu needs
	# expect ... so don't do tests unless we have dejagnu
	type -p runtest || return 0
	emake test || die "emake test failed"
}

expect_make_var() {
	touch pkgIndex.tcl-hand
	printf 'all:;echo $('$1')\ninclude Makefile' | emake --no-print-directory -s -f -
	rm -f pkgIndex.tcl-hand
}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc ChangeLog FAQ HISTORY NEWS README

	# install examples if 'doc' is set
	if use doc ; then
		insinto /usr/share/doc/${PF}/examples
		doins $(printf 'example/%s ' $(expect_make_var SCRIPTS)) || die
		docinto examples
		dodoc example/README $(printf 'example/%s.man ' $(expect_make_var _SCRIPTS_MANPAGES)) || die
	fi
}
