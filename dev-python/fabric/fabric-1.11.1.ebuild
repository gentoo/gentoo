# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit bash-completion-r1 distutils-r1

MY_PN="Fabric"
MY_P="${MY_PN}-${PV}"

COMP_HASH="83d303e9fb352deaf4885b6db0781b3d9115e9c6"

DESCRIPTION="A simple pythonic tool for remote execution and deployment"
HOMEPAGE="http://fabfile.org https://pypi.python.org/pypi/Fabric"
SRC_URI="
	mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz
	https://raw.githubusercontent.com/kbakulin/fabric-completion/${COMP_HASH}/fabric-completion.bash -> ${P}-completion.bash"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

RDEPEND="
	>=dev-python/paramiko-1.10[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		>=dev-python/python-docs-2.7.6-r1:2.7
		dev-python/alabaster[${PYTHON_USEDEP}] )
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		<dev-python/fudge-1.0[${PYTHON_USEDEP}]
		dev-python/jinja[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MY_P}"

python_prepare_all() {
	# Re-set intersphinx_mapping for doc build
	if use doc; then
		local PYTHON_DOC_ATOM=$(best_version --host-root dev-python/python-docs:2.7)
		local PYTHON_DOC_VERSION="${PYTHON_DOC_ATOM#dev-python/python-docs-}"
		local PYTHON_DOC="/usr/share/doc/python-docs-${PYTHON_DOC_VERSION}/html"
		local PYTHON_DOC_INVENTORY="${PYTHON_DOC}/objects.inv"
		sed \
			-e "s|'http://docs.python.org/2.6', None|'${PYTHON_DOC}', '${PYTHON_DOC_INVENTORY}'|" \
			-e "s|    'www'|    #'www'|" \
			-i sites/docs/conf.py || die
	fi
	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		sphinx-build -b html -c sites/docs/ sites/docs/ sites/docs/html || die
	fi
}

python_test() {
	# 1 failure, reported https://github.com/fabric/fabric/issues/1360
	sed \
		-e 's:test_abort_message_only_printed_once:_&:g' \
		-i tests/test_utils.py || die
	esetup.py test
}

python_install_all() {
	use doc && local HTML_DOCS=( sites/docs/html/. )
	distutils-r1_python_install_all
	newbashcomp "${DISTDIR}"/${P}-completion.bash  ${PN}
}
