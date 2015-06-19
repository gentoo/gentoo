# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/simplecv/simplecv-1.3.ebuild,v 1.5 2014/08/10 21:22:08 slyfox Exp $

EAPI=5

DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 vcs-snapshot

MY_PN=SimpleCV

DESCRIPTION="Python interface to several powerful open source computer vision libraries"
HOMEPAGE="http://simplecv.org/"
SRC_URI="https://github.com/sightmachine/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="shell test"

DEPEND="
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

RDEPEND="
	>=media-libs/opencv-2.4.8[python,${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	virtual/python-imaging[${PYTHON_USEDEP}]
	dev-python/pygame[${PYTHON_USEDEP}]
	shell? ( dev-python/ipython[${PYTHON_USEDEP}] )"

# 1. FeatureDetector being called with the wrong number of arguments
# 2. Remove test that according to docs shouldn't be an issue
PATCHES=(
	"${FILESDIR}"/new-support-for-opencv-2.4.3-added.patch
	"${FILESDIR}"/remove-failing-test.patch
)

src_test() {
	cd "${S}/SimpleCV/tests"
	nosetests tests.py || die "tests failed"
}

src_install() {
	distutils-r1_src_install
	if ! use shell; then
		rm -rf "${D}"/usr/bin
	fi
}
