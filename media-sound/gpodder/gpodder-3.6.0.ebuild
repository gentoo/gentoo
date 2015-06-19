# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/gpodder/gpodder-3.6.0.ebuild,v 1.3 2014/04/06 10:42:39 eva Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"
# Required for python_fix_shebang:
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 gnome2-utils

DESCRIPTION="A free cross-platform podcast aggregator"
HOMEPAGE="http://gpodder.org/"
SRC_URI="http://gpodder.org/src/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="+dbus bluetooth gstreamer ipod kernel_linux mtp test webkit"

#TODO: add QML UI deps (USE=qt4) and make pygtk optional, see README
COMMON_DEPEND=">=dev-python/eyeD3-0.7
	>=dev-python/feedparser-5.1.2
	>=dev-python/mygpoclient-1.7
	>=dev-python/pygtk-2.16:2
	dbus? ( dev-python/dbus-python )
	bluetooth? ( net-wireless/bluez )
	gstreamer? ( dev-python/gst-python:0.10 )
	ipod? ( media-libs/libgpod[python] )
	mtp? ( >=media-libs/libmtp-1.0.0 )
	webkit? ( dev-python/pywebkitgtk )"
RDEPEND="${COMMON_DEPEND}
	kernel_linux? ( sys-apps/iproute2 )"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	sys-apps/help2man
	test? (
		dev-python/minimock
		dev-python/coverage
	)"

src_prepare() {
	sed -i -e '/setup.py.*install/d' makefile || die
	# Fix for "AttributeError: 'gPodder' object has no attribute 'toolbar'":
	python_fix_shebang .
}

src_install() {
	emake DESTDIR="${D}" install
	distutils-r1_src_install
}

src_test() {
	emake releasetest
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
