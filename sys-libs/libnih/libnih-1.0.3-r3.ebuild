# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libnih/libnih-1.0.3-r3.ebuild,v 1.1 2015/05/21 08:28:24 vapier Exp $

EAPI="4"

inherit versionator eutils autotools toolchain-funcs multilib flag-o-matic

DESCRIPTION="Light-weight 'standard library' of C functions"
HOMEPAGE="https://launchpad.net/libnih"
SRC_URI="http://launchpad.net/${PN}/$(get_version_component_range 1-2)/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
IUSE="+dbus nls static-libs test +threads"

RDEPEND="dbus? ( dev-libs/expat >=sys-apps/dbus-1.2.16 )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
	test? ( dev-util/valgrind )"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.0.3-optional-dbus.patch
	epatch "${FILESDIR}"/${PN}-1.0.3-pkg-config.patch
	epatch "${FILESDIR}"/${PN}-1.0.3-signal-race.patch
	eautoreconf
}

src_configure() {
	append-lfs-flags
	econf \
		$(use_with dbus) \
		$(use_enable nls) \
		$(use_enable static-libs static) \
		$(use_enable threads) \
		$(use_enable threads threading)
}

src_install() {
	default

	# we need to be in / because upstart needs libnih
	gen_usr_ldscript -a nih $(use dbus && echo nih-dbus)
	use static-libs || rm "${ED}"/usr/$(get_libdir)/*.la
}
