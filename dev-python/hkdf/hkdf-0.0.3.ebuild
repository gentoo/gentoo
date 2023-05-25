# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools

# corresponding to upstream version 0.0.3
COMMIT_SHA1="cc3c9dbf0a271b27a7ac5cd04cc1485bbc3b4307"

inherit distutils-r1 vcs-snapshot

DESCRIPTION="HMAC-based Extract-and-Expand Key Derivation Function (HKDF)"
HOMEPAGE="https://pypi.org/project/hkdf"
SRC_URI="https://github.com/casebeer/python-hkdf/archive/${COMMIT_SHA1}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
S="${WORKDIR}/${P}.gh"

distutils_enable_tests nose
