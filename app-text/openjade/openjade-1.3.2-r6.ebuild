# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools sgml-catalog eutils flag-o-matic multilib

DESCRIPTION="Jade is an implementation of DSSSL for formatting SGML and XML documents"
HOMEPAGE="http://openjade.sourceforge.net"
SRC_URI="mirror://sourceforge/openjade/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="static-libs"

RDEPEND="app-text/sgml-common
	>=app-text/opensp-1.5.1"
DEPEND="dev-lang/perl
	${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-deplibs.patch
	epatch "${FILESDIR}"/${P}-ldflags.patch
	epatch "${FILESDIR}"/${P}-msggen.pl.patch
	epatch "${FILESDIR}"/${P}-respect-ldflags.patch
	epatch "${FILESDIR}"/${P}-libosp-la.patch
	epatch "${FILESDIR}"/${P}-gcc46.patch
	epatch "${FILESDIR}"/${P}-darwin.patch

	# Please note!  Opts are disabled.  If you know what you're doing
	# feel free to remove this line.  It may cause problems with
	# docbook-sgml-utils among other things.
	#ALLOWED_FLAGS="-O -O1 -O2 -pipe -g -march"
	strip-flags

	# Default CFLAGS and CXXFLAGS is -O2 but this make openjade segfault
	# on hppa. Using -O1 works fine. So I force it here.
	use hppa && replace-flags -O2 -O1

	ln -s config/configure.in configure.ac || die
	cp "${FILESDIR}"/${P}-acinclude.m4 acinclude.m4 || die
	rm config/missing || die

	AT_NOEAUTOMAKE=yes
	eautoreconf

	SGML_PREFIX="${EPREFIX}"/usr/share/sgml
}

src_configure() {
	# avoids dead-store elimination optimization
	# leading to segfaults on GCC 6
	# bug #592590
	append-cxxflags -fno-lifetime-dse

	# We need Prefix env, bug #287358
	export CONFIG_SHELL="${CONFIG_SHELL:-${BASH}}"
	econf \
		--enable-http \
		--enable-default-catalog="${EPREFIX}"/etc/sgml/catalog \
		--enable-default-search-path="${EPREFIX}"/usr/share/sgml \
		--enable-splibdir="${EPREFIX}"/usr/$(get_libdir) \
		--libdir="${EPREFIX}"/usr/$(get_libdir) \
		--datadir="${EPREFIX}"/usr/share/sgml/${P} \
		$(use_enable static-libs static)
}

src_compile() {
	# Bug 412725.
	unset INCLUDE

	emake -j1 SHELL="${BASH}"
}

src_install() {
	insinto /usr/$(get_libdir)

	make DESTDIR="${D}" \
		SHELL="${BASH}" \
		libdir="${EPREFIX}"/usr/$(get_libdir) \
		install install-man

	prune_libtool_files

	dosym openjade  /usr/bin/jade
	dosym onsgmls   /usr/bin/nsgmls
	dosym osgmlnorm /usr/bin/sgmlnorm
	dosym ospam     /usr/bin/spam
	dosym ospent    /usr/bin/spent
	dosym osx       /usr/bin/sgml2xml

	insinto /usr/share/sgml/${P}/
	doins dsssl/builtins.dsl

	echo 'SYSTEM "builtins.dsl" "builtins.dsl"' > ${ED}/usr/share/sgml/${P}/catalog
	insinto /usr/share/sgml/${P}/dsssl
	doins dsssl/{dsssl.dtd,style-sheet.dtd,fot.dtd}
	newins "${FILESDIR}"/${P}.dsssl-catalog catalog
# Breaks sgml2xml among other things
#	insinto /usr/share/sgml/${P}/unicode
#	doins unicode/{catalog,unicode.sd,unicode.syn,gensyntax.pl}
	insinto /usr/share/sgml/${P}/pubtext
	doins pubtext/*

	dodoc NEWS README VERSION
	dohtml doc/*.htm

	insinto /usr/share/doc/${PF}/jadedoc
	doins jadedoc/*.htm
	insinto /usr/share/doc/${PF}/jadedoc/images
	doins jadedoc/images/*
}

sgml-catalog_cat_include "/etc/sgml/${P}.cat" \
	"/usr/share/sgml/openjade-${PV}/catalog"
sgml-catalog_cat_include "/etc/sgml/${P}.cat" \
	"/usr/share/sgml/openjade-${PV}/dsssl/catalog"
sgml-catalog_cat_include "/etc/sgml/sgml-docbook.cat" \
	"/etc/sgml/${P}.cat"
