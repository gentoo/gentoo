# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 bash-completion-r1
MY_PN=StarCluster
MY_P=${MY_PN}-${PV}

DESCRIPTION="Utility for creating / managing general purpose computing clusters"
HOMEPAGE="http://web.mit.edu/star/cluster"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="LGPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="doc epydoc"

RDEPEND=">=dev-python/ssh-1.7.13[${PYTHON_USEDEP}]
	>=dev-python/boto-2.3.0[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.6-r1[${PYTHON_USEDEP}]
	>=dev-python/decorator-3.1.1[${PYTHON_USEDEP}]
	>=dev-python/pyasn1-0.0.13_beta[${PYTHON_USEDEP}]
	>=dev-python/workerpool-0.9.2[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}]
	dev-python/epydoc[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}] )
	dev-python/setuptools[${PYTHON_USEDEP}]"

S=${WORKDIR}/${MY_P}

PATCHES=( "${FILESDIR}"/${P}-requires.patch )

python_compile_all() {
	use doc && emake -C docs/sphinx html
	mkdocs() {
		local exit_status=0
		local msg="build with epydoc failed"
		pushd docs/epydoc/
		PATH=$PATH:./ PYTHONPATH="${BUILD_DIR}/lib" ./build.sh || exit_status=1
		[[ $exit_status != 0 ]] && eerror "$msg"
		popd sets
		return $exit_status
	}
	use epydoc && mkdocs
}

python_install_all() {
	distutils-r1_python_install_all
	newbashcomp "${S}"/completion/${PN}-completion.sh ${PN}
	use doc && dohtml -r docs/sphinx/_build/html/
	if use epydoc; then
		docompress -x usr/share/doc/${PF}/apidocs/api-objects.txt
		insinto usr/share/doc/${PF}/
		doins -r "${S}"/docs/apidocs/
	fi
}

python_test() {
	nosetests || die -v ${PN}/tests || die
}
