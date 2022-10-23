# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=flit

inherit distutils-r1 optfeature

DESCRIPTION="Download media files from Yle Areena"
HOMEPAGE="https://aajanki.github.io/yle-dl/ https://github.com/aajanki/yle-dl"
SRC_URI="https://github.com/aajanki/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Requires an active internet connection during tests,
PROPERTIES="test_network"
RESTRICT="test"

RDEPEND="media-video/ffmpeg
	net-misc/wget
	>=dev-python/attrs-18.1.0[${PYTHON_USEDEP}]
	>=dev-python/ConfigArgParse-0.13.0[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/progress[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]"
BDEPEND="test? (
		${RDEPEND}
		media-video/ffmpeg[gnutls]
		dev-python/pip[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

DOCS=( COPYING ChangeLog README.fi.md README.md yledl.conf.sample )

src_prepare() {
	distutils-r1_src_prepare

	# Skip 404'd files.
	sed -i -e "/def test_radio_series_redirect():/i@pytest.mark.xfail(reason='Video expired.')" \
		-e "/def test_radio_metadata_2020():/i@pytest.mark.xfail(reason='Video expired.')" \
		-e "/def test_radio_episodes_sort_order_latest_last_source():/i@pytest.mark.xfail(reason='Video expired.')" \
		-e "/def test_radio_episodes_sort_order_latest_first_source():/i@pytest.mark.xfail(reason='Video expired.')" \
		-e "/def test_radio_latest():/i@pytest.mark.xfail(reason='Video expired.')" \
		tests/integration/test_areena_radio_it.py || die
}

src_install() {
	docompress -x "/usr/share/doc/${PF}/yledl.conf.sample"
	distutils-r1_src_install
}

pkg_postinst() {
	elog "Sample configuration file has been installed to "
	elog " /usr/share/doc/yle-dl-${PVR}/yledl.conf.sample"
	elog
	optfeature "youtube-dl download engine" net-misc/youtube-dl net-misc/yt-dlp
}
