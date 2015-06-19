# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libappindicator/libappindicator-12.10.0-r200.ebuild,v 1.2 2015/05/11 14:05:57 mgorny Exp $

EAPI=5
VALA_MIN_API_VERSION="0.16"
VALA_USE_DEPEND="vapigen"

inherit autotools eutils multilib-minimal vala

DESCRIPTION="A library to allow applications to export a menu into the Unity Menu bar"
HOMEPAGE="http://launchpad.net/libappindicator"
SRC_URI="http://launchpad.net/${PN}/${PV%.*}/${PV}/+download/${P}.tar.gz"

LICENSE="LGPL-2.1 LGPL-3"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="+introspection"

RDEPEND="
	>=dev-libs/dbus-glib-0.98[${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.26:2[${MULTILIB_USEDEP}]
	>=dev-libs/libdbusmenu-0.6.2[gtk,${MULTILIB_USEDEP}]
	>=dev-libs/libindicator-12.10.0:0[${MULTILIB_USEDEP}]
	x11-libs/gtk+:2[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-1 )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig[${MULTILIB_USEDEP}]
	introspection? ( $(vala_depend) )
"

src_prepare() {
	# Don't use -Werror
	sed -i -e 's/ -Werror//' {src,tests}/Makefile.{am,in} || die

	epatch "${FILESDIR}"/${P}-disable-python.patch
	eautoreconf

	# Disable MONO for now because of http://bugs.gentoo.org/382491
	sed -i -e '/^MONO_REQUIRED_VERSION/s:=.*:=9999:' configure || die
}

multilib_src_configure() {
	if multilib_is_native_abi; then
		local -x VALAC VAPIGEN_VAPIDIR PKG_CONFIG_PATH
		use introspection && vala_src_prepare
	fi

	ECONF_SOURCE=${S} \
	econf \
		--disable-silent-rules \
		--disable-static \
		--with-gtk=2
}

multilib_src_install() {
	emake -j1 DESTDIR="${D}" install
}

multilib_src_install_all() {
	dodoc AUTHORS ChangeLog

	prune_libtool_files

	# installed by slot 3 as well
	rm -r "${D}"usr/share/gtk-doc || die
}
