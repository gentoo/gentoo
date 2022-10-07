# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Use an URL to configure email backend settings in your Django Application"
HOMEPAGE="
	https://github.com/migonzalvar/dj-email-url/
	https://pypi.org/project/dj-email-url/
"
SRC_URI="
	https://github.com/migonzalvar/dj-email-url/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"

DOCS=( CHANGELOG.rst README.rst )

distutils_enable_tests unittest
