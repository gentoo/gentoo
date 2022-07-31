# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python3_{8..11} )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1 optfeature xdg

DESCRIPTION="A free cross-platform podcast aggregator"
HOMEPAGE="https://gpodder.github.io/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+dbus bluetooth mtp"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/html5lib[${PYTHON_USEDEP}]
		dev-python/pycairo[${PYTHON_USEDEP}]
		>=dev-python/pygobject-3.22.0:3[${PYTHON_USEDEP}]
		>=dev-python/podcastparser-0.6.0[${PYTHON_USEDEP}]
		>=dev-python/mygpoclient-1.8[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dbus? ( dev-python/dbus-python[${PYTHON_USEDEP}] )
	')
	bluetooth? ( net-wireless/bluez )
	mtp? ( >=media-libs/libmtp-1.0.0:= )
	kernel_linux? ( sys-apps/iproute2 )
"
BDEPEND="
	dev-util/desktop-file-utils
	dev-util/intltool
	sys-apps/help2man
	test? (
		$(python_gen_cond_dep '
			dev-python/minimock[${PYTHON_USEDEP}]
			dev-python/pytest-httpserver[${PYTHON_USEDEP}]
		')
	)
"

distutils_enable_tests pytest

src_prepare() {
	default

	sed -i -e 's:--cov=gpodder::' makefile || die
}

python_test() {
	# These are pulled out from the Makefile to give us more control
	# See bug #795165
	# Previously, we used 'emake releasetest' in src_test
	LC_ALL=C epytest --ignore=tests --ignore=src/gpodder/utilwin32ctypes.py --doctest-modules src/gpodder/util.py src/gpodder/jsonconfig.py \
		-p no:localserver
	LC_ALL=C epytest tests --ignore=src/gpodder/utilwin32ctypes.py --ignore=src/mygpoclient \
		-p no:localserver
}

src_install() {
	emake PYTHON="${EPYTHON}" DESTDIR="${D}" install

	distutils-r1_src_install

	touch "${ED}"/usr/share/gpodder/no-update-check || die
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "track length detection for device sync (only one package is needed)" media-video/mplayer dev-python/eyeD3
	optfeature "for the YouTube extension" net-misc/yt-dlp net-misc/youtube-dl
	optfeature "iPod sync support" media-libs/libgpod
}
