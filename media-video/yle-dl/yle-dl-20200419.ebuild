# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..8} )
DISTUTILS_USE_SETUPTOOLS=rdepend
DISTUTILS_SINGLE_IMPL=true

inherit distutils-r1 eutils

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

RDEPEND="${PYTHON_DEPS}
	media-video/ffmpeg
	net-misc/wget
	$(python_gen_cond_dep '
		>=dev-python/attrs-18.1.0[${PYTHON_MULTI_USEDEP}]
		>=dev-python/configargparse-0.13.0[${PYTHON_MULTI_USEDEP}]
		dev-python/future[${PYTHON_MULTI_USEDEP}]
		dev-python/lxml[${PYTHON_MULTI_USEDEP}]
		dev-python/mini-amf[${PYTHON_MULTI_USEDEP}]
		dev-python/progress[${PYTHON_MULTI_USEDEP}]
		dev-python/pycryptodome[${PYTHON_MULTI_USEDEP}]
		dev-python/requests[${PYTHON_MULTI_USEDEP}]
	')
"
DEPEND="
	test? (
		${RDEPEND}
		media-video/ffmpeg[gnutls]
		$(python_gen_cond_dep '
			dev-python/pytest[${PYTHON_MULTI_USEDEP}]
		')
	)
"
BDEPEND="${PYTHON_DEPS}"

distutils_enable_tests setup.py

DOCS=( COPYING ChangeLog README.fi README.md yledl.conf.sample )

src_prepare() {
	default

	# Gentoo doesn't ship pycryptodomex with pycryptodome
	sed -i 's/pycryptodomex/pycryptodome/g' setup.py || die
}

src_install() {
	docompress -x "/usr/share/doc/${PF}/yledl.conf.sample"
	distutils-r1_src_install
}

pkg_postinst() {
	elog "Sample configuration file has been installed to "
	elog " /usr/share/doc/yle-dl-${PV}/yledl.conf.sample"
	elog ""
	elog "Optional download engines: "
	optfeature "php download engine using rtmpdump" "dev-lang/php:*[bcmath,cli,curl,simplexml] media-video/rtmpdump"
	optfeature "youtube-dl download engine" net-misc/youtube-dl
}
