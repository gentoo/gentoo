# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Oslo i18n library"
HOMEPAGE="
	https://opendev.org/openstack/oslo.i18n/
	https://github.com/openstack/oslo.i18n/
	https://pypi.org/project/oslo.i18n/
"
SRC_URI="$(pypi_sdist_url --no-normalize "${PN/-/.}")"
S=${WORKDIR}/${P/-/.}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86"

PATCHES=(
	"${FILESDIR}/${PN}-5.1.0-fix-py3.11.patch"
)

RDEPEND="
	>=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
	test? (
		>=dev-python/oslotest-3.2.0[${PYTHON_USEDEP}]
		>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest
