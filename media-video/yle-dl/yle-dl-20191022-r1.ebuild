# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6..7} )

inherit distutils-r1

DESCRIPTION="Download media files from Yle Areena"
HOMEPAGE="http://aajanki.github.io/yle-dl/"
SRC_URI="https://github.com/aajanki/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="libav php test +youtube-dl"

# Requires an active internet connection during tests
RESTRICT="test"

RDEPEND="
	!libav? ( media-video/ffmpeg )
	>=dev-python/attrs-18.1.0[${PYTHON_USEDEP}]
	<=dev-python/attrs-19.2.0[${PYTHON_USEDEP}]
	~dev-python/configargparse-0.13.0[${PYTHON_USEDEP}]
	dev-python/future[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/mini-amf[${PYTHON_USEDEP}]
	dev-python/progress[${PYTHON_USEDEP}]
	dev-python/pycryptodome[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	net-misc/wget
	php? (
		dev-lang/php:*[bcmath,cli,curl,simplexml]
		>=dev-libs/openssl-1.0.2:0=
		media-video/rtmpdump
	)
	youtube-dl? ( net-misc/youtube-dl[${PYTHON_USEDEP}] )
"
DEPEND="
	test? (
		${RDEPEND}
		dev-python/pytest-runner[${PYTHON_USEDEP}]
	)
"

DOCS=( COPYING ChangeLog README.fi README.md yledl.conf.sample )

src_prepare() {
	default

	# Gentoo doesn't ship pycryptodomex with pycryptodome
	sed -i 's/pycryptodomex/pycryptodome/g' setup.py || die
}

python_test() {
	# For tests to run succesfully, you need to disable network stricting
	# feature first.
	#  FEATURES="-network-sandbox test" emerge -a yle-dl
	esetup.py test
}

pkg_postinst() {
	einfo "Sample configuration file has been installed in "
	einfo " /usr/share/doc/yle-dl-2.37/yledl.conf.sample.bz2"
}
