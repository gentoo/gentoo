# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# We strip out the tests & cli code as it relies on google-apputils, and that
# module hasn't been ported to python-3.  No one currently relies on them, so
# we drop them for the sake of gaining python-3.
# https://github.com/google/apitools/issues/8

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1

DESCRIPTION="Python library to manipulate Google APIs"
HOMEPAGE="https://github.com/google/apitools"
SRC_URI="https://github.com/google/apitools/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND=">=dev-python/httplib2-0.8[${PYTHON_USEDEP}]
	>=dev-python/fasteners-0.14[${PYTHON_USEDEP}]
	>=dev-python/oauth2client-1.5.2[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	>=dev-python/setuptools-18.5[${PYTHON_USEDEP}]"
# See comment above about py3 support.
RESTRICT="test"

S="${WORKDIR}/apitools-${PV}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.5.22-use-friendy-version-checks.patch
	"${FILESDIR}"/${PN}-0.5.22-drop-cli.patch
)

src_unpack() {
	default

	# Nuke modules that we don't need.
	cd "${S}"
	rm -r samples || die
	find -name '*_test.py' -delete || die
	find -name testdata -exec rm -r {} + || die
}
