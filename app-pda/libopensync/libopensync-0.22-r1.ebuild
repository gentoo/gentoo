# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-pda/libopensync/libopensync-0.22-r1.ebuild,v 1.10 2012/05/03 20:21:00 jdhore Exp $

EAPI="3"

SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython 2.7-pypy-*"

inherit autotools eutils python

DESCRIPTION="OpenSync synchronisation framework library"
HOMEPAGE="http://www.opensync.org/"
SRC_URI="http://www.opensync.org/download/releases/${PV}/${P}.tar.bz2"

KEYWORDS="amd64 hppa ppc ppc64 x86"
SLOT="0"
LICENSE="LGPL-2.1"
IUSE="debug doc python"

RDEPEND="dev-db/sqlite:3
	dev-libs/glib:2
	dev-libs/libxml2"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc?	( app-doc/doxygen )
	python?	( >=dev-lang/swig-1.3.17 )"
#   test?   ( >=dev-libs/check-0.9.2 )"

# Tests don't pass
RESTRICT="test"

src_prepare() {
	epatch "${FILESDIR}"/${P}-fbsd.patch
	epatch "${FILESDIR}"/${P}-pythonpath.patch
	epatch "${FILESDIR}"/${P}-swig-typeerror.patch
	epatch "${FILESDIR}"/${P}-Makefile.patch
	eautoreconf

	find "${S}" -name Makefile.in -print0 | xargs -0 sed -i -e 's: -Werror::' \
		-e 's: -R $(libdir)::g'

	use python && python_copy_sources
}

src_configure() {
	do_configure() {
		econf \
			--enable-engine \
			--enable-tools \
			$(use_enable python) \
			$(use_enable debug) \
			$(use_enable debug tracing)
			#$(use_enable test unit-tests)

			sed -i -e 's:^\(hardcode_libdir_flag_spec=\).*:\1"":g' \
				-e 's:^\(runpath_var=\).*:\1DIE_RPATH_DIE:g' \
				-e 's:func_apped:func_append:g' \
				libtool
	}

	use python && python_execute_function -s do_configure
	do_configure # do this even when USE=python - we need to generate Doxyfile
}

src_compile() {
	use python \
		&& python_execute_function -d -s \
		|| default

	if use doc; then
		doxygen Doxyfile || die
	fi
}

src_install() {
	do_install() {
		emake DESTDIR="${D}" install || die
	}

	use python \
		&& python_execute_function -s do_install \
		|| do_install

	find "${D}" -name '*.la' -exec rm -f {} + || die
	dodoc AUTHORS NEWS README TODO

	if use doc; then
		dohtml docs/html/* || die
	fi
}

pkg_postinst() {
	elog "Enabling the 'debug' useflag is required for bug reports."
	elog "Also see: http://www.opensync.org/wiki/tracing"
}
