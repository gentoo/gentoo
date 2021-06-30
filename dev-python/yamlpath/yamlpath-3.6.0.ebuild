# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Command-line processors for YAML/JSON/Compatible data."
HOMEPAGE="https://github.com/wwkimball/yamlpath https://github.com/wwkimball/yamlpath/wiki"
SRC_URI="https://github.com/wwkimball/yamlpath/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="test"
RDEPEND="
	dev-python/ruamel-yaml[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"

python_prepare_all() {
	local sed_args

	sed_args=(
		-e 's|\("ruamel\.yaml\)[^"]*|\1|'
		-e '/pytest-cov/d'
		-e '/pytest-console-scripts/d'
	)
	sed "${sed_args[@]}" -i setup.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	PYTHONPATH="${S}" py.test -v tests || die "Tests failed under ${EPYTHON}"
}

yamlpath_post_src_install() {
	local sitedir=$(python_get_sitedir)
	[[ -d ${D}${sitedir} ]] || die "${D}${sitedir}: No such directory"
	insinto "${sitedir}/yamlpath"
	doins -r "${S}/yamlpath/patches"
	python_optimize "${D}${sitedir}" || die
}

src_install() {
	find "${WORKDIR}" -name tests -print0 | xargs -0 rm -rf || die
	distutils-r1_src_install

	python_foreach_impl yamlpath_post_src_install
}
