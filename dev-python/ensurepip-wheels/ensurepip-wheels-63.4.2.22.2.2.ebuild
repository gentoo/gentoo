# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SETUPTOOLS_WHL=setuptools-$(ver_cut 1-3)-py3-none-any.whl
PIP_WHL=pip-$(ver_cut 4-)-py3-none-any.whl

DESCRIPTION="Shared wheels for ensurepip Python module"
HOMEPAGE="
	https://pypi.org/project/pip/
	https://pypi.org/project/setuptools/
"
SRC_URI="
	https://files.pythonhosted.org/packages/py3/p/pip/${PIP_WHL}
	https://files.pythonhosted.org/packages/py3/s/setuptools/${SETUPTOOLS_WHL}
"
S=${DISTDIR}

# combined license of setuptools and pip (with its bundled deps)
LICENSE="Apache-2.0 BSD BSD-2 ISC LGPL-2.1+ MIT MPL-2.0 PSF-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	insinto /usr/lib/python/ensurepip
	doins "${PIP_WHL}" "${SETUPTOOLS_WHL}"
}
