# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
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
IUSE="+dbus bluetooth ipod kernel_linux mtp test"
RESTRICT="!test? ( test )"

#TODO: Make pygtk optional, see README
COMMON_DEPEND="
	>=dev-python/eyeD3-0.7
	>=dev-python/feedparser-5.1.2
	dev-python/html5lib
	>=dev-python/mygpoclient-1.7
	>=dev-python/pygtk-2.16:2
	dbus? ( dev-python/dbus-python )
	bluetooth? ( net-wireless/bluez )
	ipod? ( media-libs/libgpod[python] )
	mtp? ( >=media-libs/libmtp-1.0.0:= )
"
RDEPEND="${COMMON_DEPEND}
	kernel_linux? ( sys-apps/iproute2 )
"
DEPEND="${COMMON_DEPEND}
	dev-util/desktop-file-utils
	dev-util/intltool
	sys-apps/help2man
	test? (
		dev-python/minimock
		dev-python/coverage
	)
"

src_prepare() {
	default
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
