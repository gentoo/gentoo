# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 multiprocessing

MY_PV=${PV/_beta/b}
DESCRIPTION="Python Development Workflow for Humans"
HOMEPAGE="https://github.com/pypa/pipenv https://pypi.org/project/pipenv/"
SRC_URI="https://github.com/pypa/pipenv/archive/v${MY_PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}"/${PN}-${MY_PV}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

PATCHES=(
	"${FILESDIR}/pipenv-2023.9.8-inject-system-packages.patch"
	"${FILESDIR}/pipenv-2023.9.8-append-always-install-to-pip-extra-args.patch"
)

RDEPEND="
	>=dev-python/cerberus-1.3.2[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/click-didyoumean[${PYTHON_USEDEP}]
	>=dev-python/colorama-0.4.4[${PYTHON_USEDEP}]
	dev-python/dparse[${PYTHON_USEDEP}]
	>=dev-python/markupsafe-2.0.1[${PYTHON_USEDEP}]
	>=dev-python/pexpect-4.8.0[${PYTHON_USEDEP}]
	dev-python/pipdeptree[${PYTHON_USEDEP}]
	dev-python/plette[${PYTHON_USEDEP}]
	>=dev-python/ptyprocess-0.7.0[${PYTHON_USEDEP}]
	<dev-python/pydantic-2.0.0[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]
	<dev-python/pythonfinder-2.0.6[${PYTHON_USEDEP}]
	$(python_gen_cond_dep ' dev-python/tomli[${PYTHON_USEDEP}] ' python3_{9..10})
	>=dev-python/python-dateutil-2.8.2[${PYTHON_USEDEP}]
	>=dev-python/python-dotenv-0.21.0[${PYTHON_USEDEP}]
	>=dev-python/virtualenv-20.0.35[${PYTHON_USEDEP}]
	>=dev-python/requests-2.26.0[${PYTHON_USEDEP}]
	dev-python/ruamel-yaml[${PYTHON_USEDEP}]
	dev-python/shellingham[${PYTHON_USEDEP}]
	dev-python/tomli[${PYTHON_USEDEP}]
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
	sed --in-place -e "s/import click, plette, tomlkit/import click\n\import tomlkit\nfrom pipenv.vendor import plette/g" pipenv/project.py || die "Failed patching pipenv/project.py"

	local pkgName
	local jobs=$(makeopts_jobs)
	local packages=( cerberus colorama click click_didyoumean dotenv dparse markupsafe \
					 pexpect pep517 pipdeptree plette ptyprocess pydantic pyparsing pythonfinder \
					 requests urllib3 shellingham tomli tomlkit )
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

	# remove python ruaml yaml
	sed --in-place -e \
		"s/from pipenv\.vendor\.ruamel\.yaml import YAML/from ruamel\.yaml import YAML/g" \
		pipenv/patched/safety/util.py || die "Failed sed in ruaml-yaml"
	sed --in-place -e \
		"s/from pipenv\.vendor\.ruamel\.yaml\.error import MarkedYAMLError/from ruamel\.yaml\.error import MarkedYAMLError/g" \
		pipenv/patched/safety/util.py || die "Failed sed in ruamel-yaml"

	rm -vR pipenv/vendor/ruamel || die "Failed removing ruamel-yaml from vendor"

	for fname in Makefile README.md ruamel.*.LICENSE vendor.txt; do
		rm -v pipenv/vendor/$fname || die "Failed removing pipenv/vendor/${fname}"
	done

	sed --in-place -e "s/pipenv.vendor.pythonfinder.utils.get_python_version/pythonfinder.utils.get_python_version/g" tests/unit/test_utils.py || die "Failed patching tests"

	rm -Rfv pipenv/vendor || die "Could not vendor"
	rm -Rfv examples || die "Could not remove examples"
}

python_test() {
	epytest -m "not cli and not needs_internet" tests/unit/
}
