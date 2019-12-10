# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{6,7} )
PYTHON_REQ_USE="sqlite"
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 gnome2-utils

DESCRIPTION="A free cross-platform podcast aggregator"
HOMEPAGE="https://gpodder.github.io/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="+dbus bluetooth kernel_linux mtp test"
RESTRICT="!test? ( test )"

# As in Fedora: re-enable >=dev-python/eyeD3-0.7[${PYTHON_USEDEP}] and
# ipod? ( media-libs/libgpod[python,${PYTHON_USEDEP}] ) once they
# support python3
COMMON_DEPEND="
	dev-python/html5lib[${PYTHON_USEDEP}]
	dev-python/isort[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	>=dev-python/pygobject-3.22.0:3[${PYTHON_USEDEP}]
	>=dev-python/podcastparser-0.6.0[${PYTHON_USEDEP}]
	>=dev-python/mygpoclient-1.8[${PYTHON_USEDEP}]
	dbus? ( dev-python/dbus-python[${PYTHON_USEDEP}] )
	bluetooth? ( net-wireless/bluez )
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

src_install() {
	emake PYTHON=python3 DESTDIR="${D}" install
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
