# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=${PN#ensurepip-}
WHL=${MY_PN}-${PV}-py3-none-any.whl

DESCRIPTION="Shared pip wheel for ensurepip Python module"
HOMEPAGE="https://pypi.org/project/pip/"
SRC_URI="
	https://files.pythonhosted.org/packages/py3/${MY_PN::1}/${MY_PN}/${WHL}
"
S=${DISTDIR}

LICENSE="Apache-2.0 BSD BSD-2 ISC LGPL-2.1+ MIT MPL-2.0 PSF-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	!<dev-python/ensurepip-wheels-100
"

src_install() {
	insinto /usr/lib/python/ensurepip
	doins "${WHL}"
}
