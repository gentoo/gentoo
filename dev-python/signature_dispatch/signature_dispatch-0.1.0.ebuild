# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="Execute the first function that matches the given arguments"
HOMEPAGE="
	https://github.com/kalekundert/signature_dispatch/
	https://pypi.org/project/signature-dispatch/"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

distutils_enable_tests pytest
