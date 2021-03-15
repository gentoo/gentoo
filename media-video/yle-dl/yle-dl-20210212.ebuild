# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1 optfeature

DESCRIPTION="Download media files from Yle Areena"
HOMEPAGE="https://aajanki.github.io/yle-dl/ https://github.com/aajanki/yle-dl"
SRC_URI="https://github.com/aajanki/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Requires an active internet connection during tests,
# FEATURES="-network-sandbox" to test.
RESTRICT="test"

RDEPEND="media-video/ffmpeg
	net-misc/wget
	>=dev-python/attrs-18.1.0[${PYTHON_USEDEP}]
	>=dev-python/configargparse-0.13.0[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/progress[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]"
BDEPEND="test? (
		${RDEPEND}
		media-video/ffmpeg[gnutls]
		dev-python/pytest[${PYTHON_USEDEP}]
	)"

# Use 'pytest --geoblocked' to only test using non-geo restricted videos.
distutils_enable_tests setup.py

DOCS=( COPYING ChangeLog README.fi README.md yledl.conf.sample )

src_install() {
	docompress -x "/usr/share/doc/${PF}/yledl.conf.sample"
	distutils-r1_src_install
}

pkg_postinst() {
	elog "Sample configuration file has been installed to "
	elog " /usr/share/doc/yle-dl-${PV}/yledl.conf.sample"
	elog ""
	elog "Optional download engines: "
	optfeature "youtube-dl download engine" net-misc/youtube-dl
}
