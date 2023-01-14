# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1

DESCRIPTION="Module implementing munkres algorithm for the Assignment Problem"
HOMEPAGE="https://pypi.org/project/munkres/ https://github.com/bmc/munkres"
SRC_URI="https://github.com/bmc/munkres/archive/release-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-release-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~x86"

distutils_enable_tests pytest
