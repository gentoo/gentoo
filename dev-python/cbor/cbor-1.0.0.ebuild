# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

EGIT_COMMIT="b3af679e7cf3e12d50acb83c3c591fc5db9a658d"
DESCRIPTION="RFC 7049 - Concise Binary Object Representation"
HOMEPAGE="https://github.com/brianolson/cbor_py
	https://pypi.org/project/cbor/"
SRC_URI="
	https://github.com/brianolson/cbor_py/archive/${EGIT_COMMIT}.tar.gz
		-> ${P}.gh.tar.gz"
S=${WORKDIR}/cbor_py-${EGIT_COMMIT}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 x86 ~amd64-linux ~x86-linux"

distutils_enable_tests unittest
