# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1

COMMIT="981cad270c2558aeb8eccaf42cfcf9fabbbed199"
DESCRIPTION="A module for (de)serialization to and from VDF, Valve's key-value text format"
HOMEPAGE="
	https://github.com/ValvePython/vdf/
	https://pypi.org/project/vdf/
"
SRC_URI="
	https://github.com/Matoking/vdf/archive/${COMMIT}.tar.gz
		-> ${P}.gh.tar.gz
"
S="${WORKDIR}/${PN}-${COMMIT}"
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 ~x86"

distutils_enable_tests pytest
