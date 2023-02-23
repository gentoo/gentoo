# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Python client for the Prometheus monitoring system"
HOMEPAGE="
	https://github.com/prometheus/client_python/
	https://pypi.org/project/prometheus-client/
"
SRC_URI="
	https://github.com/prometheus/client_python/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"
S="${WORKDIR}/client_python-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	dev-python/twisted[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
