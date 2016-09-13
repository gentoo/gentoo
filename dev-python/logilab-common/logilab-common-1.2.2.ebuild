# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} pypy )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Useful miscellaneous modules used by Logilab projects"
HOMEPAGE="http://www.logilab.org/project/logilab-common https://pypi.python.org/pypi/logilab-common"
SRC_URI="ftp://ftp.logilab.org/pub/common/${P}.tar.gz mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc test"

RDEPEND=">=dev-python/six-1.4.0[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? (
		$(python_gen_cond_dep 'dev-python/egenix-mx-base[${PYTHON_USEDEP}]' python2_7)
		dev-python/pytz[${PYTHON_USEDEP}]
	)
	doc? ( $(python_gen_cond_dep 'dev-python/epydoc[${PYTHON_USEDEP}]' python2_7) )"

PATCHES=( "${FILESDIR}/${P}-test-namespace-fix.patch" )

python_prepare_all() {
	sed -i \
		-e 's:(CURDIR):{S}/${P}:' \
		doc/makefile || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		# Based on the doc build in Arfrever's ebuild. It works
		pushd doc > /dev/null
		mkdir -p apidoc || die
		epydoc --parse-only -o apidoc --html -v --no-private --exclude=__pkginfo__ --exclude=setup --exclude=test \
			-n "Logilab's common library" "$(ls -d ../build/lib/logilab/common/)" build \
			|| die "Generation of documentation failed"
	fi
}

python_install_all() {
	distutils-r1_python_install_all

	doman doc/pytest.1
	use doc &&  HTML_DOCS=( doc/apidoc/. )
}

python_test() {
	# https://www.logilab.org/ticket/149345
	# Prevent timezone related failure.
	export TZ=UTC

	"${PYTHON}" bin/pytest-local || die "Tests fail with ${EPYTHON}"
}
