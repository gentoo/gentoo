# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-pda/libopensync/libopensync-0.22.ebuild,v 1.20 2012/05/03 20:21:00 jdhore Exp $

inherit eutils

DESCRIPTION="OpenSync synchronisation framework library"
HOMEPAGE="http://www.opensync.org/"
SRC_URI="http://dev.gentooexperimental.org/~peper/distfiles/${P}.tar.bz2"

KEYWORDS="amd64 hppa ppc ppc64 x86"
SLOT="0"
LICENSE="LGPL-2.1"
IUSE="debug doc python"
#profiling" - needs tau - http://www.cs.uoregon.edu/research/tau/

# Tests are not doing anything in 0.22
#		$(use_enable test unit-tests) \
RESTRICT="test"

RDEPEND=">=dev-db/sqlite-3
	>=dev-libs/glib-2
	dev-libs/libxml2
	python? ( >=dev-lang/python-2.2 )
	debug? ( >=dev-libs/check-0.9.2 )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	python? ( >=dev-lang/swig-1.3.17 )"

src_unpack() {
	unpack ${A}

	cd "${S}"
	epatch "${FILESDIR}/${P}-fbsd.patch"
}

src_compile() {
	econf \
		--enable-engine \
		--enable-tools \
		$(use_enable python) \
		$(use_enable debug) \
		$(use_enable debug tracing) \
		|| die "econf failed"

	emake || die "emake failed"

	use doc && doxygen Doxyfile
}
src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS ChangeLog NEWS README TODO
	use doc && dohtml docs/html/*
}

pkg_preinst() {
	has_version "<${CATEGORY}/${PN}-0.21"
	previous_less_than_0_21=$?
}

pkg_postinst() {
	elog "Building with 'debug' useflag is highly encouraged"
	elog "and requiered for bug reports."
	elog "Also see http://www.opensync.org/wiki/tracing"

	if [[ $previous_less_than_0_21 = 0 ]] ; then
		echo ""
		elog "You are updating from version prior to 0.21 and hence you need to rebuild your db."
		elog "How: http://www.opensync.org/wiki/FAQ#HowdoIcleanupasyncgroupfortesting"
		elog "Why: http://www.nabble.com/Not-Unique-UID-fix-in-subversion-tf3167800.html"
	fi
}
