# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1 multiprocessing

MY_PV=${PV/_beta/b}
DESCRIPTION="Python Development Workflow for Humans"
HOMEPAGE="https://github.com/pypa/pipenv https://pypi.org/project/pipenv/"
SRC_URI="https://github.com/pypa/pipenv/archive/v${MY_PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}"/${PN}-${MY_PV}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

PATCHES=(
	"${FILESDIR}/pipenv-2022.9.24-inject-site-packages.patch"
	"${FILESDIR}/pipenv-2022.12.19-append-always-install.patch"
)

RDEPEND="
	dev-python/attrs[${PYTHON_USEDEP}]
	>=dev-python/cerberus-1.3.2[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
	>=dev-python/colorama-0.4.4[${PYTHON_USEDEP}]
	>=dev-python/markupsafe-2.0.1[${PYTHON_USEDEP}]
	>=dev-python/pexpect-4.8.0[${PYTHON_USEDEP}]
	>=dev-python/ptyprocess-0.7.0[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.8.2[${PYTHON_USEDEP}]
	>=dev-python/python-dotenv-0.21.0[${PYTHON_USEDEP}]
	>=dev-python/virtualenv-20.0.35[${PYTHON_USEDEP}]
	dev-python/virtualenv-clone[${PYTHON_USEDEP}]
	>=dev-python/requests-2.26.0[${PYTHON_USEDEP}]
	dev-python/ruamel-yaml[${PYTHON_USEDEP}]
	dev-python/tomlkit[${PYTHON_USEDEP}]
"

BDEPEND="
	${RDEPEND}
	test? (
		dev-python/flaky[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

# IMPORTANT: The following sed command patches the vendor direcotry
# in the pipenv source. Attempts to simply bump the version of the
# package without checking that it works is likely to fail
# The vendored packages should eventually all be removed
# see: https://bugs.gentoo.org/717666
src_prepare() {
	local pkgName
	local jobs=$(makeopts_jobs)
	local packages=( attr attrs cerberus click colorama dotenv markupsafe \
					 pexpect ptyprocess pyparsing requests urllib3 tomlkit )
	for pkgName in ${packages[@]}; do
		find ./ -type f -print0 | \
			xargs --max-procs="${jobs}" --null \
			sed --in-place \
				-e "s/from pipenv.vendor import ${pkgName}/import ${pkgName}/g" \
				-e "s/from pipenv.vendor.${pkgName}\(.*\) import \(\w*\)/from ${pkgName}\1 import \2/g"\
				-e "s/import pipenv.vendor.${pkgName} as ${pkgName}/import ${pkgName}/g" \
				-e "s/from .vendor import ${pkgName}/import ${pkgName}/g" || die "Failed to sed for ${pkgName}"
	done

	distutils-r1_src_prepare

	# remove vendored versions
	for pkgName in ${packages[@]}; do
		find  ./pipenv/vendor -regextype posix-extended -regex ".*${pkgName}$" -prune -exec rm -rvf {} + || die
		# package names can be foo-bar, their module will be however foo_bar
		find  ./pipenv/vendor -regextype posix-extended -regex ".*${pkgName/_/-}" -prune -exec rm -rvf {} + || die
	done

	find  ./pipenv/vendor -regextype posix-extended -regex '.*cached[_-]property.*' -prune -exec rm -rvf {} + || die

	find ./ -type f -print0 | \
		xargs --max-procs="${jobs}" --null \
		sed --in-place \
			-e "s/from pipenv\.vendor import plette, toml, tomlkit, vistir/from pipenv\.vendor import plette, toml, vistir\\nimport tomlkit/g"

	# remove tomlkit from vendoring
	for fname in pipenv/utils/toml.py tests/integration/conftest.py; do
		sed --in-place -e "s/from pipenv\.vendor import toml, tomlkit/from pipenv\.vendor import toml\\nimport tomlkit/g" $fname || die "Failed sed in $fname"
	done
	#for fname in "tests/unit/test_vendor.py "; do
	#	sed --in-place -e "s/from pipenv\.vendor import tomlkit/import tomlkit/g" $fname || die "Failed sed in tomlkit"
	#done
	# remove python ruaml yaml
	sed --in-place -e "s/from pipenv\.vendor\.ruamel\.yaml import YAML/from ruaml\.yaml import YAML/g" pipenv/patched/safety/util.py || die "Failed sed in ruaml-yaml"
	sed --in-place -e "s/from pipenv\.vendor\.ruamel\.yaml\.error import MarkedYAMLError/from ruaml\.yaml\.error import MarkedYAMLError/g" pipenv/patched/safety/util.py || die "Failed sed in ruamel-yaml"

	rm -vR pipenv/vendor/ruamel || die "Failed removing ruamel-yaml from vendor"

	for fname in Makefile README.md README.rst ruamel.*.LICENSE vendor.txt; do
		rm -v pipenv/vendor/$fname || die "Failed removing pipenv/vendor/$fname"
	done

}

python_test() {
	epytest -m "not cli and not needs_internet" tests/unit/
}
