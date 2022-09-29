# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Python bindings for media-libs/rtmidi implemented using Cython"
HOMEPAGE="
	https://pypi.org/project/python-rtmidi/
	https://spotlightkid.github.io/python-rtmidi/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+alsa jack"

# Most of these tests do not play nicely with the sandbox, some only
# work with exactly the same version of rtmidi as the bundled one, and
# several fail even with disabled sandbox unless there are actual MIDI
# I/O devices present.
RESTRICT="test"

DEPEND="media-libs/rtmidi[alsa?,jack?]"
RDEPEND="${DEPEND}"
BDEPEND="dev-python/cython[${PYTHON_USEDEP}]
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.9-unbundle_rtmidi.patch
)

distutils_enable_sphinx docs
distutils_enable_tests unittest

src_prepare() {
	distutils-r1_src_prepare

	# Just in case
	rm -r src/rtmidi || die
	rm src/_rtmidi.cpp || die
}

python_test() {
	cd "${T}" || die
	eunittest "${S}"/tests
}
