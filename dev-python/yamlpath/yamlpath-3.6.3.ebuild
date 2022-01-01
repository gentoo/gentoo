# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Command-line processors for YAML/JSON/Compatible data."
HOMEPAGE="https://github.com/wwkimball/yamlpath https://github.com/wwkimball/yamlpath/wiki"
SRC_URI="
	https://github.com/wwkimball/yamlpath/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/ruamel-yaml[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-console-scripts[${PYTHON_USEDEP}]
		dev-ruby/hiera-eyaml
	)
"

distutils_enable_tests --install pytest

python_prepare_all() {
	sed -e '/ruamel\.yaml/d' \
		-e '/pytest-cov/d' \
		-e "/find_packages/s/()/(exclude=\['tests'\])/" \
		-i setup.py || die

	distutils-r1_python_prepare_all
}

python_install() {
	distutils-r1_python_install

	# install and optimize yamlpath/patches/aliasstyle.py
	local sitedir=$(python_get_sitedir)
	[[ -d ${D}${sitedir} ]] || die "${D}${sitedir}: No such directory"
	insinto "${sitedir}/yamlpath"
	doins -r "${S}/yamlpath/patches"
	python_optimize "${D}${sitedir}"
}
