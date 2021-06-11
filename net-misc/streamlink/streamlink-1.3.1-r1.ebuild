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
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD-2 Apache-2.0"
SLOT="0"
IUSE="doc test"
RESTRICT="!test? ( test )"

# >=urllib3-1.23 only needed for python2, but requests pulls some version anyways, so we might as well guarantee at least that ver for py3 too
DEPEND="
	$(python_gen_cond_dep '
		>dev-python/requests-2.21.0[${PYTHON_MULTI_USEDEP}]
		>=dev-python/urllib3-1.23[${PYTHON_MULTI_USEDEP}]
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
		doc? (
			dev-python/sphinx[${PYTHON_MULTI_USEDEP}]
			dev-python/docutils[${PYTHON_MULTI_USEDEP}]
			dev-python/recommonmark[${PYTHON_MULTI_USEDEP}]
		)
		test? (
			dev-python/mock[${PYTHON_MULTI_USEDEP}]
			dev-python/requests-mock[${PYTHON_MULTI_USEDEP}]
			dev-python/pytest[${PYTHON_MULTI_USEDEP}]
			dev-python/freezegun[${PYTHON_MULTI_USEDEP}]
		)
	')"

python_configure_all() {
	# Avoid iso-639, iso3166 dependencies since we use pycountry.
	export STREAMLINK_USE_PYCOUNTRY=1
}

python_compile_all() {
	use doc && emake -C docs html man
}

python_test() {
	esetup.py test
}

python_install_all() {
	if use doc; then
		local HTML_DOCS=( docs/_build/html/. )
		doman docs/_build/man/*
	fi
	distutils-r1_python_install_all
}
