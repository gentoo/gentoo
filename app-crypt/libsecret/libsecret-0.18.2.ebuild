# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/libsecret/libsecret-0.18.2.ebuild,v 1.3 2015/06/21 10:37:05 zlogene Exp $

EAPI="5"
PYTHON_COMPAT=( python2_7 )
VALA_MIN_API_VERSION=0.18
VALA_USE_DEPEND=vapigen

inherit gnome2 python-any-r1 vala virtualx

DESCRIPTION="GObject library for accessing the freedesktop.org Secret Service API"
HOMEPAGE="https://live.gnome.org/Libsecret"

LICENSE="LGPL-2.1+ Apache-2.0" # Apache-2.0 license is used for tests only
SLOT="0"
IUSE="+crypt debug +introspection test vala"
REQUIRED_USE="vala? ( introspection )"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ppc64 ~sparc ~x86 ~amd64-fbsd"

COMMON_DEPEND="
	>=dev-libs/glib-2.38:2
	crypt? ( >=dev-libs/libgcrypt-1.2.2:0= )
	introspection? ( >=dev-libs/gobject-introspection-1.29 )
"
RDEPEND="${COMMON_DEPEND}
	>=gnome-base/gnome-keyring-3
"
# Add ksecrets to RDEPEND when it's added to portage
DEPEND="${COMMON_DEPEND}
	dev-libs/libxslt
	dev-util/gdbus-codegen
	>=dev-util/gtk-doc-am-1.9
	>=dev-util/intltool-0.35.0
	sys-devel/gettext
	virtual/pkgconfig
	test? (
		dev-python/mock
		introspection? (
			${PYTHON_DEPS}
			>=dev-libs/gjs-1.32
			dev-python/pygobject:3 )
	)
	vala? ( $(vala_depend) )
"

src_prepare() {
	use vala && vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	DOCS="AUTHORS ChangeLog NEWS README"
	gnome2_src_configure \
		--enable-manpages \
		--disable-strict \
		--disable-coverage \
		--disable-static \
		$(use_enable crypt gcrypt) \
		$(use_enable introspection) \
		$(use_enable vala)
}

src_test() {
	Xemake check
}
