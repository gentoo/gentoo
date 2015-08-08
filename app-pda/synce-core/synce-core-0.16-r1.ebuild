# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

PYTHON_DEPEND="python? 2:2.7"

inherit flag-o-matic python

DESCRIPTION="Base libraries, including RAPI protocol, tools and dccm daemon"
HOMEPAGE="http://sourceforge.net/projects/synce/"
SRC_URI="mirror://sourceforge/synce/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="python static-libs"

# AC_PATH_PROG -> pppd -> net-dialup/ppp
# AC_PATH_PROG -> ifconfig -> sys-apps/net-tools
RDEPEND="!app-pda/synce-connector
	>=dev-libs/dbus-glib-0.100
	>=dev-libs/glib-2.28
	!dev-libs/librapi2
	!dev-libs/libsynce
	net-dialup/ppp
	sys-apps/net-tools
	virtual/libgudev
	virtual/udev
	python? (
		>=dev-python/pyrex-0.9.6
		dev-python/python-gudev
		)"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_setup() {
	if use python; then
		python_set_active_version 2
		python_pkg_setup
	fi
}

src_prepare() {
	# AC_PATH_PROG -> dhclient ->
	local dhclient=true
	type -P dhclient >/dev/null && dhclient=dhclient
	sed -i -e "s:dhclient:${dhclient}:" configure || die

	use python && python_convert_shebangs -r 2 .
}

src_configure() {
	append-cflags -fno-strict-aliasing

	# hal OR udev -> udev -> dbus -> build all of bluetooth, odccm, udev
	econf \
		$(use_enable static-libs static) \
		--enable-dccm-file-support \
		--enable-odccm-support \
		--disable-hal-support \
		--enable-udev-support \
		--enable-bluetooth-support \
		$(use_enable python python-bindings)
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc BUGS ChangeLog README* TODO
	newdoc bluetooth/README README.bluetooth

	# prune_libtool_files() from eutils.eclass fails wrt #421197
	find "${ED}" -name '*.la' -exec rm -f {} +

	# Always remove static archive from site-packages
	use static-libs && find "${ED}" -name pyrapi2.a -exec rm -f {} +
}
