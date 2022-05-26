# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1

DESCRIPTION="WSDL parsing services package for Web Services for Python"
HOMEPAGE="
	https://github.com/pycontribs/wstools/
	https://pypi.org/project/wstools/
"
SRC_URI="
	https://github.com/pycontribs/wstools/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/pbr-3.0.0[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}/wstools-0.4.8-fix-py3.10.patch"
)

src_prepare() {
	# remove the dep on pytest-runner
	sed -i -e '/setup_requires/d' setup.py || die
	# disabling xdist breaks random plugins
	sed -i -e 's@-p no:xdist@@' pytest.ini || die
	distutils-r1_src_prepare
	export PBR_VERSION=${PV}
}
