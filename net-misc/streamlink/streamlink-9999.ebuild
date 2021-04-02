# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/streamlink/${PN}.git"
	GIT_ECLASS="git-r3"
fi

PYTHON_COMPAT=( python3_{7,8} )
PYTHON_REQ_USE='xml(+),threads(+)'
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1 ${GIT_ECLASS}

DESCRIPTION="CLI for extracting streams from websites to a video player of your choice"
HOMEPAGE="https://streamlink.github.io/"

if [[ ${PV} != 9999* ]]; then
	SRC_URI="https://github.com/streamlink/${PN}/releases/download/${PV}/${P}.tar.gz"
	SRC_URI+=" https://dev.gentoo.org/~leio/distfiles/streamlink.1-${PV}.man.xz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD-2 Apache-2.0"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	$(python_gen_cond_dep '
		>dev-python/requests-2.21.0[${PYTHON_MULTI_USEDEP}]
		dev-python/isodate[${PYTHON_MULTI_USEDEP}]
		dev-python/websocket-client[${PYTHON_MULTI_USEDEP}]
		dev-python/pycountry[${PYTHON_MULTI_USEDEP}]
		>=dev-python/pycryptodome-3.4.3[${PYTHON_MULTI_USEDEP}]
	')
"
RDEPEND="${DEPEND}
	media-video/rtmpdump
	media-video/ffmpeg
"
BDEPEND="
	$(python_gen_cond_dep '
		test? (
			dev-python/mock[${PYTHON_MULTI_USEDEP}]
			dev-python/requests-mock[${PYTHON_MULTI_USEDEP}]
			dev-python/pytest[${PYTHON_MULTI_USEDEP}]
			>=dev-python/freezegun-1.0.0[${PYTHON_MULTI_USEDEP}]
		)
	')"

src_prepare() {
	distutils-r1_src_prepare
	if [[ ${PV} != 9999* ]]; then
		mv "${WORKDIR}"/streamlink.1-${PV}.man "${WORKDIR}"/streamlink.1 || die
	fi
}

python_configure_all() {
	# Avoid iso-639, iso3166 dependencies since we use pycountry.
	export STREAMLINK_USE_PYCOUNTRY=1
}

python_test() {
	esetup.py test
}

python_install_all() {
	distutils-r1_python_install_all
	if [[ ${PV} != 9999* ]]; then
		doman "${WORKDIR}"/streamlink.1
	fi
}
