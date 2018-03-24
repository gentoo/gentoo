# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="Command-line tool for structural, content-preserving transformation of PDF files"
HOMEPAGE="http://qpdf.sourceforge.net/"
SRC_URI="mirror://sourceforge/qpdf/${P}.tar.gz"

LICENSE="Artistic-2"
SLOT="0/13" # subslot = libqpdf soname version
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~m68k-mint ~sparc-solaris"
IUSE="doc examples perl static-libs test"

RDEPEND="dev-libs/libpcre
	sys-libs/zlib"
DEPEND="${RDEPEND}
	test? (
		sys-apps/diffutils
		media-libs/tiff
		app-text/ghostscript-gpl[tiff]
	)"
# Only need perl for the installed tools.
RDEPEND+=" perl? ( >=dev-lang/perl-5.8 )"

DOCS=( ChangeLog README TODO )

src_prepare() {
	# manually install docs
	sed -i "/docdir/d" make/libtool.mk || die
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_enable test test-compare-images)
}

src_install() {
	default

	if ! use perl ; then
		rm "${ED}"/usr/bin/fix-qdf || die
		rm "${ED}"/usr/share/man/man1/fix-qdf.1 || die
	fi

	if use doc ; then
		dodoc doc/qpdf-manual.pdf
		dohtml doc/*
	fi

	if use examples ; then
		dobin examples/build/.libs/*
	fi

	prune_libtool_files
}
