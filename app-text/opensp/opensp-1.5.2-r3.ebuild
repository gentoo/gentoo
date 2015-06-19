# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/opensp/opensp-1.5.2-r3.ebuild,v 1.18 2014/06/25 19:55:40 pacho Exp $

EAPI=5
inherit eutils flag-o-matic

MY_P=${P/opensp/OpenSP}

DESCRIPTION="A free, object-oriented toolkit for SGML parsing and entity management"
HOMEPAGE="http://openjade.sourceforge.net/"
SRC_URI="mirror://sourceforge/openjade/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="doc nls static-libs test"

DEPEND="nls? ( sys-devel/gettext )
	doc? (
		app-text/xmlto
		app-text/docbook-xml-dtd:4.1.2
	)
	test? (
		app-text/docbook-xml-dtd:4.5
		app-text/openjade
		app-text/sgml-common
	)"
RDEPEND=""

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-1.5-gcc34.patch \
		"${FILESDIR}"/${P}-fix-segfault.patch
}

src_configure() {
	# The following filters are taken from openjade's ebuild. See bug #100828.
	# Please note!  Opts are disabled.  If you know what you're doing
	# feel free to remove this line.  It may cause problems with
	# docbook-sgml-utils among other things.
	#ALLOWED_FLAGS="-O -O1 -O2 -pipe -g -march"
	strip-flags

	econf \
		--enable-http \
		--enable-default-catalog="${EPREFIX}"/etc/sgml/catalog \
		--enable-default-search-path="${EPREFIX}"/usr/share/sgml \
		--datadir="${EPREFIX}"/usr/share/sgml/${P} \
		$(use_enable nls) \
		$(use_enable doc doc-build) \
		$(use_enable static-libs static)
}

src_compile() {
	emake pkgdocdir="${EPREFIX}"/usr/share/doc/${PF}
}

src_test() {
	# Skipping tests known not to work
	emake SHOWSTOPPERS= check
	SANDBOX_PREDICT="${SANDBOX_PREDICT%:/}"
}

src_install() {
	emake \
		DESTDIR="${D}" \
		pkgdocdir="${EPREFIX}"/usr/share/doc/${PF} \
		install

	prune_libtool_files

	dodoc AUTHORS BUGS ChangeLog NEWS README
}
