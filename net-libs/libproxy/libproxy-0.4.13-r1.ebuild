# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit cmake-multilib eutils flag-o-matic mono-env python-r1

DESCRIPTION="Library for automatic proxy configuration management"
HOMEPAGE="https://github.com/libproxy/libproxy"
SRC_URI="https://github.com/libproxy/libproxy/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"

KEYWORDS="alpha amd64 arm ~hppa ~ia64 ~mips ppc ~ppc64 ~sh ~sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"

IUSE="gnome kde mono networkmanager perl python spidermonkey test webkit"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# NOTE: mozjs/spidermonkey might still cause problems like #373397 ?
CDEPEND="
	gnome? ( dev-libs/glib:2[${MULTILIB_USEDEP}] )
	mono? ( dev-lang/mono )
	networkmanager? ( sys-apps/dbus:0[${MULTILIB_USEDEP}] )
	perl? ( dev-lang/perl:= )
	python? ( ${PYTHON_DEPS} )
	spidermonkey? ( >=dev-lang/spidermonkey-1.8.5:0= )
	webkit? ( net-libs/webkit-gtk:4 )
"
DEPEND="${CDEPEND}
	virtual/pkgconfig:0[${MULTILIB_USEDEP}]
"
RDEPEND="${CDEPEND}
	kde? ( || (
		kde-frameworks/kconfig:5
		kde-apps/kreadconfig:4
	) )
"
# avoid dependency loop, bug #467696
PDEPEND="networkmanager? ( net-misc/networkmanager )"

PATCHES=(
	# get-pac-test freezes when run by the ebuild, succeeds when building
	# manually; virtualx.eclass doesn't help :(
	"${FILESDIR}/${PN}-0.4.10-disable-pac-test.patch"

	# prevent dependency loop with networkmanager, libsoup, glib-networking; bug #467696
	# https://github.com/libproxy/libproxy/issues/28
	"${FILESDIR}/${PN}-0.4.11-avoid-nm-build-dep.patch"

	# Gentoo's spidermonkey doesn't set Version: in mozjs18[57].pc
	"${FILESDIR}/${PN}-0.4.12-mozjs.pc.patch"

	# https://github.com/libproxy/libproxy/issues/27
	"${FILESDIR}/${PN}-0.4.12-macosx.patch"
)

multilib_src_configure() {
	local mycmakeargs=(
		'-DPERL_VENDORINSTALL=ON'
		# WITH_VALA just copies the .vapi file over and needs no deps,
		# hence always enable it unconditionally
		'-DWITH_VALA=ON'
		"-DCMAKE_C_FLAGS=${CFLAGS}"
		"-DCMAKE_CXX_FLAGS=${CXXFLAGS}"
		"-DGMCS_EXECUTABLE='${EPREFIX}/usr/bin/mcs'"
		"-DWITH_GNOME3=$(usex gnome)"
		"-DWITH_KDE=$(usex kde)"
		"-DWITH_DOTNET=$(multilib_is_native_abi	&& usex mono || echo 'OFF')"
		"-DWITH_NM=$(usex networkmanager)"
		"-DWITH_PERL=$(multilib_is_native_abi && usex perl || echo 'OFF')"
		"-DWITH_PYTHON=$(multilib_is_native_abi	&& usex python || echo 'OFF')"
		"-DWITH_MOZJS=$(multilib_is_native_abi && usex spidermonkey || echo 'OFF')"
		"-DWITH_WEBKIT3=$(multilib_is_native_abi && usex webkit || echo 'OFF')"
		"-DBUILD_TESTING=$(usex test)"
	)
	cmake-utils_src_configure
}

src_configure() {
	[[ ${CHOST} == *-solaris* ]] && append-libs -lsocket -lnsl

	use python && python_setup
	multilib-minimal_src_configure
}

multilib_src_install_all() {
	doman "${FILESDIR}/proxy.1"
	use python && python_foreach_impl python_domodule 'bindings/python/libproxy.py'
}
