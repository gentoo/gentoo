# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1

DESCRIPTION="Python Development Workflow for Humans"
HOMEPAGE="https://github.com/pypa/pipenv https://pypi.org/project/pipenv/"
SRC_URI="https://github.com/pypa/pipenv/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"

PATCHES=(
	"${FILESDIR}/pipenv-${PV}-inject-system-packages.patch"
	"${FILESDIR}/pipenv-${PV}-append-always-install-to-pip-extra-args.patch"
)

RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/click-didyoumean[${PYTHON_USEDEP}]
	dev-python/colorama[${PYTHON_USEDEP}]
	>=dev-python/importlib-metadata-8.4.0[${PYTHON_USEDEP}]
	<dev-python/importlib-metadata-9.0.0[${PYTHON_USEDEP}]
	>=dev-python/pexpect-4.8.0[${PYTHON_USEDEP}]
	~dev-python/pipdeptree-2.30.0[${PYTHON_USEDEP}]
	~dev-python/plette-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/ptyprocess-0.7.0[${PYTHON_USEDEP}]
	>=dev-python/python-dotenv-0.21.0[${PYTHON_USEDEP}]
	>=dev-python/pythonfinder-3.0.0[${PYTHON_USEDEP}]
	dev-python/shellingham[${PYTHON_USEDEP}]
	dev-python/tomlkit[${PYTHON_USEDEP}]
	>=dev-python/virtualenv-20.0.35[${PYTHON_USEDEP}]
"

BDEPEND="
	${RDEPEND}
	test? (
		dev-python/flaky[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
	)
"

# IMPORTANT: The following sed command patches the vendor direcotry
# in the pipenv source. Attempts to simply bump the version of the
# package without checking that it works is likely to fail
# The vendored packages should eventually all be removed
# see: https://bugs.gentoo.org/717666
src_prepare() {
	sed --in-place -e \
	"s/import click, plette, tomlkit/import click\n\import tomlkit\nfrom pipenv.vendor import plette/g" \
	pipenv/project.py || die "Failed patching pipenv/project.py"

	local pkgName
	local packages=(
		colorama
		click
		click_didyoumean
		dotenv
		pexpect
		pipdeptree
		plette
		pythonfinder
		shellingham
		tomli
		tomlkit
		importlib_metadata
		packaging
	)

	for pkgName in "${packages[@]}"; do
	find ./ -type f -exec sed --in-place \
		-e "s/from pipenv.vendor import ${pkgName}/import ${pkgName}/g" \
		-e "s/from pipenv.vendor.${pkgName}\(.*\) import \(\w*\)/from ${pkgName}\1 import \2/g"\
		-e "s/import pipenv.vendor.${pkgName} as ${pkgName}/import ${pkgName}/g" \
		-e "s/from .vendor import ${pkgName}/import ${pkgName}/g" \
		-e "s/from .vendor.${pkgName}/from ${pkgName}/g" {} + || die "Failed to sed for ${pkgName}"
	done

	# disable coverage in tests
	sed -i -e '/\[tool\.pytest\.ini_options\]/,/\[/ { /addopts/d; /plugins/d; }' pyproject.toml || die

	distutils-r1_src_prepare

	# remove vendored versions
	for pkgName in "${packages[@]}"; do
	# Match the name directly (works for directories and files)
	# We use -o (OR) to handle both the original name and the hyphenated version
	find ./pipenv/vendor \( -name "${pkgName}" -o -name "${pkgName/_/-}" \) \
		-prune -exec rm -rvf {} + || die "Failed to remove vendored ${pkgName}"
	done

	find tests/ -type f -name "*.py" -exec sed -i \
		-e "s/pipenv\.vendor\.pythonfinder\.utils\.get_python_version/pythonfinder.utils.get_python_version/g" \
		-e "s/from pipenv\.vendor /from /g" \
		-e "s/import pipenv\.vendor\./import /g" \
		{} + || die "Failed to devendor tests"

	for fname in Makefile README.md vendor.txt; do
		rm -v "pipenv/vendor/${fname}" || die "Failed removing pipenv/vendor/${fname}"
	done

	rm -rv pipenv/vendor examples docs benchmarks || die "Failed to remove dirs"

}

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test() {
	local -x PYTHONPATH="${S}:${PYTHONPATH}"
	epytest -m "not cli and not needs_internet" tests/unit/
}
