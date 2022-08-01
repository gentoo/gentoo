# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
# backport from python3.9
PYTHON_COMPAT=( python3_8 )

inherit distutils-r1

DESCRIPTION="Resolve a name to an object"
HOMEPAGE="
	https://github.com/graingert/pkgutil-resolve-name/
	https://pypi.org/project/pkgutil_resolve_name/
"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"
