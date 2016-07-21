# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit autotools eutils toolchain-funcs

DESCRIPTION="Text formatter used for man pages"
HOMEPAGE="https://www.gnu.org/software/groff/groff.html"
SRC_URI="mirror://gnu/groff/${P}.tar.gz
	l10n_ja? ( https://dev.gentoo.org/~naota/patch/${PN}-1.22.1-japanese.patch.bz2 )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~ia64-hpux ~x86-interix ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="examples X l10n_ja"

RDEPEND="
	X? (
		x11-libs/libX11
		x11-libs/libXt
		x11-libs/libXmu
		x11-libs/libXaw
		x11-libs/libSM
		x11-libs/libICE
	)"
DEPEND="${RDEPEND}
	l10n_ja? ( virtual/yacc )"

DOCS=( BUG-REPORT ChangeLog MORE.STUFF NEWS PROBLEMS PROJECTS README REVISION TODO VERSION )

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.19.2-man-unicode-dashes.patch #16108 #17580 #121502
	epatch "${FILESDIR}"/${PN}-1.22.2-parallel-mom.patch #487276

	# Make sure we can cross-compile this puppy
	if tc-is-cross-compiler ; then
		sed -i \
			-e '/^GROFFBIN=/s:=.*:=${EPREFIX}/usr/bin/groff:' \
			-e '/^TROFFBIN=/s:=.*:=${EPREFIX}/usr/bin/troff:' \
			-e '/^GROFF_BIN_PATH=/s:=.*:=:' \
			-e '/^GROFF_BIN_DIR=/s:=.*:=:' \
			contrib/*/Makefile.sub \
			doc/Makefile.in \
			doc/Makefile.sub || die "cross-compile sed failed"
	fi

	local pfx=$(usex prefix ' Prefix' '')
	cat <<-EOF >> tmac/mdoc.local
	.ds volume-operating-system Gentoo${pfx}
	.ds operating-system Gentoo${pfx}/${KERNEL}
	.ds default-operating-system Gentoo${pfx}/${KERNEL}
	EOF

	if use l10n_ja ; then
		epatch "${WORKDIR}"/${PN}-1.22.1-japanese.patch #255292 #350534 #450796
		eautoconf
		eautoheader
	fi

	# make sure we don't get a crappy `g' nameprefix on UNIX systems with real
	# troff (GROFF_G macro runs some test to see, its own troff doesn't satisfy)
	sed -i -e 's/^[ \t]\+g=g$/g=/' configure || die
}

src_configure() {
	econf \
		--with-appresdir="${EPREFIX}"/usr/share/X11/app-defaults \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		$(use_with X x) \
		$(usex l10n_ja '--enable-japanese' '')
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	default

	# The following links are required for man #123674
	dosym eqn /usr/bin/geqn
	dosym tbl /usr/bin/gtbl

	if ! use examples ; then
		rm -rf "${ED}"/usr/share/doc/${PF}/examples
		rm -f "${ED}"/usr/share/doc/${PF}/pdf/mom-pdf.pdf
	fi
}
