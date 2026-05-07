# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
# >= 6.2.1 uses a bunch of setuptools hooks instead of vanilla setuptools
# https://github.com/streamlink/streamlink/commit/194d9bc193f5285bc1ba33af5fd89209a96ad3a7
DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{11..14} )
PYTHON_REQ_USE='xml(+),threads(+)'
inherit distutils-r1

DESCRIPTION="CLI for extracting streams from websites to a video player of your choice"
HOMEPAGE="https://streamlink.github.io/"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/streamlink/${PN}.git"
	inherit git-r3

	BDEPEND+="
		$(python_gen_cond_dep '
			>=dev-python/versioningit-2.0.0[${PYTHON_USEDEP}]
		')
	"
else
	VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/streamlink.asc
	inherit verify-sig

	SRC_URI="
		https://github.com/streamlink/${PN}/releases/download/${PV}/${P}.tar.gz
		verify-sig? ( https://github.com/streamlink/${PN}/releases/download/${PV}/${P}.tar.gz.asc )
	"

	KEYWORDS="~amd64 ~arm ~arm64 ~x86"

	BDEPEND+=" verify-sig? ( sec-keys/openpgp-keys-streamlink )"
fi

LICENSE="BSD-2 Apache-2.0"
SLOT="0"

# See https://github.com/streamlink/streamlink/commit/9d8156dd794ee0919297cd90d85bcc11b8a28358 for chardet/charset-normalizer dep
RDEPEND="
	media-video/ffmpeg
	$(python_gen_cond_dep '
		dev-python/certifi[${PYTHON_USEDEP}]
		|| (
			dev-python/chardet[${PYTHON_USEDEP}]
			dev-python/charset-normalizer[${PYTHON_USEDEP}]
		)
		>=dev-python/requests-2.30.0[${PYTHON_USEDEP}]
		dev-python/isodate[${PYTHON_USEDEP}]
		>=dev-python/lxml-4.6.4[${PYTHON_USEDEP}]
		>=dev-python/websocket-client-1.2.1[${PYTHON_USEDEP}]
		dev-python/pycountry[${PYTHON_USEDEP}]
		>=dev-python/pycryptodome-3.4.3[${PYTHON_USEDEP}]
		>dev-python/pysocks-1.5.7-r9999[${PYTHON_USEDEP}]
		>=dev-python/trio-0.22.0[${PYTHON_USEDEP}]
		>=dev-python/trio-websocket-0.9.0[${PYTHON_USEDEP}]
		>=dev-python/urllib3-2.0.0[${PYTHON_USEDEP}]
	')
"
BDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/setuptools-77[${PYTHON_USEDEP}]
		test? (
			>=dev-python/freezegun-1.5.0[${PYTHON_USEDEP}]
			dev-python/pytest-trio[${PYTHON_USEDEP}]
			dev-python/requests-mock[${PYTHON_USEDEP}]
		)
	')
"

EPYTEST_PLUGINS=( pytest-trio freezegun requests-mock )

distutils_enable_tests pytest
