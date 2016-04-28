# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit cmake-multilib eutils flag-o-matic mono-env python-r1

DESCRIPTION="Library for automatic proxy configuration management"
HOMEPAGE="https://github.com/libproxy/libproxy"
LICENSE="LGPL-2.1+"
SRC_URI="https://github.com/libproxy/libproxy/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="gnome kde mono networkmanager perl python spidermonkey test webkit"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# NOTE: mozjs/spidermonkey might still cause problems like #373397 ?
# NOTE: webkit-gtk:3, not :2, needed for libjavascriptcoregtk support
CDEPEND="
	gnome? ( >=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}] )
	kde? ( >=kde-base/kdelibs-4.4.5 )
	mono? ( dev-lang/mono )
	networkmanager? ( >=sys-apps/dbus-1.6.18-r1[${MULTILIB_USEDEP}] )
	perl? ( dev-lang/perl:= )
	python? ( ${PYTHON_DEPS} )
	spidermonkey? ( >=dev-lang/spidermonkey-1.8.5:0= )
	webkit? ( >=net-libs/webkit-gtk-1.6:3= )"
DEPEND="${CDEPEND}
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]"
RDEPEND="${CDEPEND}
	kde? ( || (
		kde-frameworks/kconfig:5
		kde-apps/kreadconfig:4
	) )"
# avoid dependency loop, bug #467696
PDEPEND="networkmanager? ( net-misc/networkmanager )"

PATCHES=(
	# get-pac-test freezes when run by the ebuild, succeeds when building
	# manually; virtualx.eclass doesn't help :(
	"${FILESDIR}/${PN}-0.4.10-disable-pac-test.patch"

	# Gentoo's spidermonkey doesn't set Version: in mozjs18[57].pc
	"${FILESDIR}/${PN}-0.4.12-mozjs.pc.patch"

	"${FILESDIR}/${PN}-0.4.12-macosx.patch"

	# prevent dependency loop with networkmanager, libsoup, glib-networking; bug #467696
	"${FILESDIR}/${PN}-0.4.11-avoid-nm-build-dep.patch"

	"${FILESDIR}/${PN}-0.4.12-Make_the_KDE_config_module_optional.patch"
)

multilib_src_configure() {
	local mycmakeargs=(
		'-DPERL_VENDORINSTALL=ON'
		# WITH_VALA just copies the .vapi file over and needs no deps,
		# hence always enable it unconditionally
		'-DWITH_VALA=ON'
		"-DCMAKE_C_FLAGS=${CFLAGS}"
		"-DCMAKE_CXX_FLAGS=${CXXFLAGS}"
		"-DWITH_GNOME3=$(usex gnome)"
		"-DWITH_KDE=$(usex kde)"
		"-DWITH_DOTNET=$(multilib_is_native_abi	&& usex mono || echo 'OFF')"
		"-DWITH_NM=$(usex networkmanager)"
		"-DWITH_PERL=$(multilib_is_native_abi	&& usex perl || echo 'OFF')"
		"-DWITH_PYTHON=$(multilib_is_native_abi	&& usex python || echo 'OFF')"
		"-DWITH_MOZJS=$(multilib_is_native_abi	&& usex spidermonkey || echo 'OFF')"
		"-DWITH_WEBKIT=$(multilib_is_native_abi	&& usex webkit || echo 'OFF')"
		"-DWITH_WEBKIT3=$(multilib_is_native_abi && usex webkit || echo 'OFF')"
		"-DBUILD_TESTING=$(usex test)"
	)
	cmake-utils_src_configure
}

src_configure() {
	[[ ${CHOST} == *-solaris* ]] && append-libs '-lsocket' '-lnsl'

	use python && python_setup
	multilib-minimal_src_configure
}

multilib_src_install_all() {
	DOCS=('AUTHORS' 'ChangeLog' 'NEWS' 'README')
	einstalldocs

	use python && python_foreach_impl python_domodule 'bindings/python/libproxy.py'
}
