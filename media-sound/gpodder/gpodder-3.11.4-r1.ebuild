# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( python3_{11..13} )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1 optfeature xdg

DESCRIPTION="A free cross-platform podcast aggregator"
HOMEPAGE="https://gpodder.github.io/"
SRC_URI="
	https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+dbus bluetooth mtp"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/html5lib[${PYTHON_USEDEP}]
		dev-python/pycairo[${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		dev-python/podcastparser[${PYTHON_USEDEP}]
		dev-python/mygpoclient[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dbus? ( dev-python/dbus-python[${PYTHON_USEDEP}] )
	')
	bluetooth? ( net-wireless/bluez )
	mtp? ( media-libs/libmtp:= )
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

PATCHES=(
	"${FILESDIR}/${P}-make-build.patch"
)

distutils_enable_tests pytest

src_prepare() {
	default

	sed -e 's:--cov=gpodder::' -i makefile || die

	emake PYTHON="${EPYTHON}" build
}

python_test() {
	# These are pulled out from the Makefile to give us more control
	# See bug #795165
	# Previously, we used 'emake releasetest' in src_test

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1

	local -x EPYTEST_IGNORE=(
		src/gpodder/utilwin32ctypes.py
	)

	epytest \
		--ignore=tests \
		--doctest-modules src/gpodder/util.py \
		src/gpodder/jsonconfig.py

	epytest tests \
		--ignore=src/mygpoclient \
		-p pytest_httpserver
}

src_install() {
	distutils-r1_src_install

	touch "${ED}/usr/share/gpodder/no-update-check" || die
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "track length detection for device sync (only one package is needed)" media-video/mplayer dev-python/eyeD3
	optfeature "for the YouTube extension" net-misc/yt-dlp
	optfeature "iPod sync support" media-libs/libgpod
}
