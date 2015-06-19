# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libart_lgpl/libart_lgpl-2.3.21-r2.ebuild,v 1.12 2015/06/13 10:13:12 pacho Exp $

EAPI="5"
GCONF_DEBUG="no"
GNOME_TARBALL_SUFFIX="bz2"
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2 multilib-minimal

DESCRIPTION="a LGPL version of libart"
HOMEPAGE="http://www.levien.com/libart"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20140508-r6
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)"
DEPEND=">=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]"

# The provided tests are interactive only
RESTRICT="test"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/libart2-config
)

DOCS="AUTHORS ChangeLog NEWS README"

src_prepare() {
	gnome2_src_prepare

	# Fix crosscompiling, bug #185684
	rm "${S}"/art_config.h
	epatch "${FILESDIR}"/${PN}-2.3.21-crosscompile.patch

	# Do not build tests if not required
	epatch "${FILESDIR}"/${PN}-2.3.21-no-test-build.patch

	AT_NOELIBTOOLIZE=yes eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	gnome2_src_configure \
		--disable-static
}
