# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Javascript minifier written in python."
HOMEPAGE="http://opensource.perlig.de/rjsmin/"
SRC_URI="
	https://github.com/ndparker/rjsmin/archive/${PV}.tar.gz -> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

distutils_enable_tests pytest
