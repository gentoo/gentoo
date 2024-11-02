# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN="JACK-Client"

inherit distutils-r1 virtualx pypi

DESCRIPTION="JACK Audio Connection Kit client for Python"
HOMEPAGE="
	https://pypi.org/project/JACK-Client/
	https://github.com/spatialaudio/jackclient-python
"
SRC_URI="https://files.pythonhosted.org/packages/80/79/6af550e4fa3f5ff384e8114a1a18572627744b335956f0be06e4e0fc815a/jack_client-${PV}.tar.gz"
S="${WORKDIR}/jack_client-${PV}"

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

# sphinx_last_updated_by_git not in the tree yet
#distutils_enable_sphinx doc dev-python/sphinx-last-updated-by-git
distutils_enable_tests pytest

python_test() {
	# virtx lets tests autolaunch dbus-daemon
	virtx epytest
}
