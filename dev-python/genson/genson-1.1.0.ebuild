# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..10} )
inherit distutils-r1 pypi

DESCRIPTION="GenSON is a powerful, user-friendly JSON Schema generator built in Python"
HOMEPAGE="https://pypi.org/project/genson/ https://github.com/wolverdude/GenSON/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="test? ( dev-python/jsonschema[${PYTHON_USEDEP}] )"

distutils_enable_tests unittest
