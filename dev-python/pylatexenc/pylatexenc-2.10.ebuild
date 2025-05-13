# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="Simple LaTeX parser providing latex-to-unicode and unicode-to-latex conversion"
HOMEPAGE="
	https://github.com/phfaist/pylatexenc/
	https://pypi.org/project/pylatexenc/
"
SRC_URI="
	https://github.com/phfaist/pylatexenc/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

distutils_enable_tests pytest
