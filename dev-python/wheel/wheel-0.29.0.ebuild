# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{3,4,5} pypy pypy3 )

inherit distutils-r1 eutils

DESCRIPTION="A built-package format for Python"
HOMEPAGE="https://pypi.python.org/pypi/wheel"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="doc test"

RDEPEND="dev-python/jsonschema[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
#	test? (
#		dev-python/keyring
#		dev-python/keyrings_alt
#		dev-python/ed25519ll
#		dev-python/pytest[${PYTHON_USEDEP}]
#	)
#"

# Fails somehow
RESTRICT=test

python_test() {
	sed \
		-e 's:--cov=wheel::g' \
		-i setup.cfg || die
	py.test -v -v || die "testsuite failed under ${EPYTHON}"
}

pkg_postinst() {
	optfeature "Signature support" \
		dev-python/keyring \
		dev-python/keyrings_alt \
		dev-python/ed25519ll
}
