# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )
inherit distutils-r1

DESCRIPTION="httpstat visualizes cURL statistics in a way of beauty and clarity"
HOMEPAGE="https://github.com/reorx/httpstat"
SRC_URI="https://github.com/reorx/${PN}/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

RDEPEND="net-misc/curl:*"

# Requires access to google.com and http2.akamai.com
RESTRICT="test"
PROPERTIES="test_network"

PATCHES=( "${FILESDIR}"/${PN}-1.2.1-gentoo-tests.patch )

src_prepare() {
	# ast.Constant.s was removed in py3.14
	sed -e 's/\.value\.s$/.value.value/' -i setup.py || die
	distutils-r1_src_prepare
}

python_test() {
	./httpstat_test.sh || die "Tests failed with ${EPYTHON}"
}
