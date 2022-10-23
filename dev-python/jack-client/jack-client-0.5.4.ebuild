# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 virtualx

MY_PN="JACK-Client"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="JACK Audio Connection Kit client for Python"
HOMEPAGE="
	https://pypi.org/project/JACK-Client/
	https://github.com/spatialaudio/jackclient-python
"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# Tests require disabling the sandbox, ALSA with at least one functioning
# PCM output device, and a very specific JACK server to even start (so far
# only media-sound/jack2[alsa] has worked for me).
RESTRICT="test"

BDEPEND="dev-python/cffi[${PYTHON_USEDEP}]"
RDEPEND="${BDEPEND}
	dev-python/numpy[${PYTHON_USEDEP}]
	virtual/jack"

S="${WORKDIR}"/${MY_P}

# sphinx_last_updated_by_git not in the tree yet
#distutils_enable_sphinx doc dev-python/sphinx-last-updated-by-git
distutils_enable_tests pytest

python_test() {
	# virtx lets tests autolaunch dbus-daemon
	virtx epytest
}
