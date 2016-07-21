# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit cmake-multilib eutils flag-o-matic mono python-r1

DESCRIPTION="Library for automatic proxy configuration management"
HOMEPAGE="https://code.google.com/p/libproxy/"
SRC_URI="https://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="gnome kde mono networkmanager perl python spidermonkey test webkit"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# NOTE: mozjs/spidermonkey might still cause problems like #373397 ?
# NOTE: webkit-gtk:3, not :2, needed for libjavascriptcoregtk support
RDEPEND="gnome? ( >=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}] )
	kde? ( >=kde-base/kdelibs-4.4.5 )
	mono? ( dev-lang/mono )
	networkmanager? ( >=sys-apps/dbus-1.6.18-r1[${MULTILIB_USEDEP}] )
	perl? ( dev-lang/perl:= )
	python? ( ${PYTHON_DEPS} )
	spidermonkey? ( >=dev-lang/spidermonkey-1.8.5:0= )
	webkit? ( >=net-libs/webkit-gtk-1.6:3= )"
DEPEND="${RDEPEND}
	kde? ( dev-util/automoc )
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]"
# avoid dependency loop, bug #467696
PDEPEND="networkmanager? ( net-misc/networkmanager )"

src_prepare() {
	# Gentoo's spidermonkey doesn't set Version: in mozjs18[57].pc
	epatch "${FILESDIR}/${P}-mozjs.pc.patch"

	# get-pac-test freezes when run by the ebuild, succeeds when building
	# manually; virtualx.eclass doesn't help :(
	epatch "${FILESDIR}/${PN}-0.4.10-disable-pac-test.patch"

	epatch "${FILESDIR}"/${P}-macosx.patch

	# prevent dependency loop with networkmanager, libsoup, glib-networking; bug #467696
	epatch "${FILESDIR}/${PN}-0.4.11-avoid-nm-build-dep.patch"
}

src_configure() {
	[[ ${CHOST} == *-solaris* ]] && append-libs -lsocket -lnsl

	use python && python_setup
	multilib-minimal_src_configure
}

multilib_src_configure() {
	# WITH_VALA just copies the .vapi file over and needs no deps,
	# hence always enable it unconditionally
	local mycmakeargs=(
			-DPERL_VENDORINSTALL=ON
			-DCMAKE_C_FLAGS="${CFLAGS}"
			-DCMAKE_CXX_FLAGS="${CXXFLAGS}"
			$(cmake-utils_use_with gnome GNOME3)
			$(multilib_is_native_abi && cmake-utils_use_with kde KDE4 \
				|| echo -DWITH_KDE4=OFF)
			$(multilib_is_native_abi && cmake-utils_use_with mono DOTNET \
				|| echo -DWITH_DOTNET=OFF)
			$(cmake-utils_use_with networkmanager NM)
			$(multilib_is_native_abi && cmake-utils_use_with perl PERL \
				|| echo -DWITH_PERL=OFF)
			$(multilib_is_native_abi && cmake-utils_use_with python PYTHON \
				|| echo -DWITH_PYTHON=OFF)
			$(multilib_is_native_abi && cmake-utils_use_with spidermonkey MOZJS \
				|| echo -DWITH_MOZJS=OFF)
			$(multilib_is_native_abi && cmake-utils_use_with webkit WEBKIT \
				|| echo -DWITH_WEBKIT=OFF)
			$(multilib_is_native_abi && cmake-utils_use_with webkit WEBKIT3 \
				|| echo -DWITH_WEBKIT3=OFF)
			-DWITH_VALA=ON
			$(cmake-utils_use test BUILD_TESTING)
	)
	cmake-utils_src_configure
}

multilib_src_install_all() {
	DOCS="AUTHORS ChangeLog NEWS README"
	einstalldocs

	if use python; then
		python_foreach_impl python_domodule bindings/python/libproxy.py || die
	fi
}
