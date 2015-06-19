# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/oosuite/oosuite-0.45.ebuild,v 1.2 2015/04/08 08:05:16 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='tk?'

inherit distutils-r1 eutils

MYPN="OOSuite"
MYPID="f/f3"

DESCRIPTION="OpenOpt suite of Python modules for numerical optimization"
HOMEPAGE="http://openopt.org/"
SRC_URI="http://openopt.org/images/${MYPID}/${MYPN}.zip -> ${MYPN}-${PV}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples minimal tk"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	!minimal? (
		dev-python/cvxopt[glpk,${PYTHON_USEDEP}]
		dev-python/lp_solve[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/setproctitle[${PYTHON_USEDEP}]
		sci-libs/nlopt[python]
		sci-libs/scipy[${PYTHON_USEDEP}] )"
DEPEND="
	app-arch/unzip
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/PythonPackages"

OO_DIRS="DerApproximator FuncDesigner OpenOpt SpaceFuncs"

python_prepare() {
	# reorganize SpaceFuncs
	pushd SpaceFuncs > /dev/null
	mkdir SpaceFuncs
	cp __version__.py SpaceFuncs || die
	mv SpaceFuncs.py __init__.py kernel SpaceFuncs || die
	popd > /dev/null
	local d
	for d in ${OO_DIRS}; do
		pushd ${d} > /dev/null
		find . -name "*COPYING*" -delete
		find . -type d -name examples -or -name tests -or -name doc \
			-exec rm -r '{}' +
		distutils-r1_python_prepare
		popd > /dev/null
	done
}

src_prepare() {
	distutils-r1_src_prepare
	# move all examples and tests to ease installation in proper directory
	mkdir "${WORKDIR}/examples"
	local d e
	for d in ${OO_DIRS}; do
		mkdir "${WORKDIR}/examples/${d}" || die
		for e in $(find ${d} -type d -name examples -or -name tests -or -name doc); do
			mv ${e} "${WORKDIR}/examples/${d}/" || die
		done
	done
}

python_compile() {
	local d
	for d in ${OO_DIRS}; do
		pushd ${d} > /dev/null
		distutils-r1_python_compile
		popd > /dev/null
	done
}

python_test() {
	local d t oldpath=${PYTHONPATH}
	for d in ${OO_DIRS}; do
		PYTHONPATH="${BUILD_DIR}/${d}/build/lib:${PYTHONPATH}"
	done
	export PYTHONPATH
	cd "${WORKDIR}"/examples
	# limit the tests, other need more dependencies
	for t in \
		DerApproximator/tests/t_check.py \
		FuncDesigner/examples/sle1.py \
		OpenOpt/examples/nlp_1.py \
		SpaceFuncs/examples/triangle.py
	do
		"${PYTHON}" ${t} || die "test ${t} failed"
	done
	export PYTHONPATH=${oldpath}
}

python_install() {
	local d
	for d in ${OO_DIRS}; do
		pushd ${d} > /dev/null
		distutils-r1_python_install
		popd > /dev/null
	done
	use examples && EXAMPLES="${WORKDIR}"/examples
}
