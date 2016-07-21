# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )
GENTOO_DEPEND_ON_PERL=no

inherit distutils-r1 eutils perl-module flag-o-matic autotools

DESCRIPTION="File transfer over OBEX for mobile phones"
HOMEPAGE="http://dev.zuckschwerdt.org/openobex/wiki/ObexFtp"
SRC_URI="mirror://sourceforge/openobex/${P}.tar.bz2"
SLOT="0"

LICENSE="GPL-2"
KEYWORDS="amd64 hppa ppc ~sparc x86"
IUSE="bluetooth debug perl python ruby tcl"

RDEPEND="dev-libs/openobex
	bluetooth? ( net-wireless/bluez )
	perl? ( dev-lang/perl:= )
	ruby? ( dev-lang/ruby:1.9 )
	tcl? ( dev-lang/tcl:0= )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	epatch "${FILESDIR}"/${P}-fixruby.patch \
		"${FILESDIR}"/${P}-gentoo.patch \
		"${FILESDIR}"/${P}-fix-ruby19.patch
	# Python bindings are built/installed manually.
	sed -e "/MAYBE_PYTHON_ = python/d" -i swig/Makefile.am || die "sed failed"

	eautoreconf
}

src_configure() {
	if use debug ; then
		strip-flags
		append-flags "-g -DOBEXFTP_DEBUG=5"
	fi

	local MYRUBY
	use ruby && MYRUBY="RUBY=/usr/bin/ruby19"

	econf \
		$(use_enable bluetooth) \
		$(use_enable perl) \
		$(use_enable python) \
		$(use_enable tcl) \
		$(use_enable ruby) \
		${MYRUBY}
}

src_compile() {
	default

	if use python; then
		pushd swig/python/
		distutils-r1_src_compile
		popd
	fi
}

src_install() {
	# -j1 because "make -fMakefile.ruby install" fails
	# upstream added -j1 to that command so it should be removed
	# from here in the next version bump
	emake -j1 DESTDIR="${D}" INSTALLDIRS=vendor install

	if use python; then
		pushd swig/python/
		distutils-r1_src_install
		popd
	fi

	dodoc AUTHORS ChangeLog NEWS README* THANKS TODO
	dohtml doc/*.html

	# Install examples
	insinto /usr/share/doc/${PF}/examples
	doins examples/*.c
	use perl && doins examples/*.pl
	use python && doins examples/*.py
	use ruby && doins examples/*.rb
	use tcl && doins examples/*.tcl

	if use perl ; then
		perl_delete_localpod
		perl_delete_packlist
	fi
}

pkg_postinst() {
	use python && distutils-r1_pkg_postinst
}

pkg_postrm() {
	use python && distutils-r1_pkg_postrm
}
