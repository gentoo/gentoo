# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/vcdimager/vcdimager-0.7.24.ebuild,v 1.12 2014/06/18 20:32:24 mgorny Exp $

EAPI=5
inherit eutils multilib-minimal

DESCRIPTION="GNU VCDimager"
HOMEPAGE="http://www.vcdimager.org/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE="+xml static-libs"

RDEPEND=">=dev-libs/libcdio-0.90-r1[-minimal,${MULTILIB_USEDEP}]
	dev-libs/popt
	xml? ( dev-libs/libxml2 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS="AUTHORS BUGS ChangeLog FAQ HACKING NEWS README THANKS TODO"

src_prepare() {
	# Avoid building useless programs. Bug #226249
	sed -i \
		-e 's/check_PROGRAMS =/check_PROGRAMS +=/' \
		-e 's/noinst_PROGRAMS =/check_PROGRAMS =/' \
		test/Makefile.in || die
	sed -i \
		-e 's/noinst_PROGRAMS =/check_PROGRAMS =/' \
		example/Makefile.in || die
}

multilib_src_configure() {
	# We disable the xmltest because the configure script includes differently
	# than the actual XML-frontend C files.
	local myconf
	if use xml && multilib_is_native_abi ; then
		myconf="--with-xml-prefix=${EPREFIX}/usr --disable-xmltest"
	else
		myconf="--without-xml-frontend"
	fi
	multilib_is_native_abi || myconf="${myconf} --without-cli-frontend"
	ECONF_SOURCE="${S}" \
		econf $(use_enable static-libs static) ${myconf}
}

multilib_src_install_all() {
	prune_libtool_files
	einstalldocs
}
