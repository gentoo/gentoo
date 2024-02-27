# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} pypy3 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

EGIT_COMMIT=8609892a88f571bc10110603c173832cd100cb44
MY_P=${PN}-${EGIT_COMMIT}
DESCRIPTION="Python ASN.1 library with a focus on performance and a pythonic API"
HOMEPAGE="
	https://github.com/wbond/asn1crypto/
	https://pypi.org/project/asn1crypto/
"
SRC_URI="
	https://github.com/wbond/asn1crypto/archive/${EGIT_COMMIT}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

distutils_enable_tests unittest
