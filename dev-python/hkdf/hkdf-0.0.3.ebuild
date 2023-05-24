# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="HMAC-based Extract-and-Expand Key Derivation Function (HKDF)"
HOMEPAGE="https://pypi.org/project/hkdf"
SRC_URI="https://files.pythonhosted.org/packages/c3/be/327e072850db181ce56afd51e26ec7aa5659b18466c709fa5ea2548c935f/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
