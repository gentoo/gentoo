# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="A Python CD-DA ripper preferring accuracy over speed (forked from morituri)"
HOMEPAGE="https://github.com/whipper-team/whipper"
SRC_URI="https://github.com/whipper-team/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-libs/libsndfile:="
RDEPEND="
	${DEPEND}
	app-cdr/cdrdao
	>=dev-libs/libcdio-paranoia-0.94_p2
	>=dev-python/pycdio-2.1.0[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/python-musicbrainz-ngs[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/ruamel-yaml[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	media-libs/mutagen[${PYTHON_USEDEP}]
	media-sound/sox[flac]"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? ( dev-python/twisted[${PYTHON_USEDEP}] )"

distutils_enable_tests unittest

PATCHES=( "${FILESDIR}/${PN}-0.7.0-cdparanoia-name-fix.patch" )

python_prepare_all() {
	# accurip test totally depends on network access
	rm "${PN}"/test/test_common_accurip.py || die

	export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

	distutils-r1_python_prepare_all
}
