# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

# PyPI doesn't have tests, repo doesn't have tags
COMMIT=1f690acd378c0a24037931520fdc465180ca0948
MY_P=${PN}-${COMMIT}

DESCRIPTION="Yet Another SWF Parser"
HOMEPAGE="https://github.com/facundobatista/yaswfp"
SRC_URI="
	https://github.com/facundobatista/yaswfp/archive/${COMMIT}.tar.gz -> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

distutils_enable_tests unittest
