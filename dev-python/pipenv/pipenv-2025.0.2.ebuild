# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1 multiprocessing optfeature

MY_PV=${PV/_beta/b}
DESCRIPTION="Python Development Workflow for Humans"
HOMEPAGE="https://github.com/pypa/pipenv https://pypi.org/project/pipenv/"
SRC_URI="https://github.com/pypa/pipenv/archive/v${MY_PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}"/${PN}-${MY_PV}

LICENSE="MIT"
SLOT="0"
IUSE="scan"
KEYWORDS="~amd64 ~arm64 ~riscv"


PATCHES=(
	"${FILESDIR}/pipenv-${PV}-inject-system-packages.patch"
	"${FILESDIR}/pipenv-${PV}-append-always-install-to-pip-extra-args.patch"
	"${FILESDIR}/pipenv-${PV}-fix-graph-subcommand.patch"
	"${FILESDIR}/pipenv-${PV}-fix-update-subcommand.patch"
)

RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/click-didyoumean[${PYTHON_USEDEP}]
	>=dev-python/colorama-0.4.4[${PYTHON_USEDEP}]
	>=dev-python/pexpect-4.8.0[${PYTHON_USEDEP}]
	~dev-python/pipdeptree-2.23.4[${PYTHON_USEDEP}]
	~dev-python/plette-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/ptyprocess-0.7.0[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]
	~dev-python/pythonfinder-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/python-dotenv-0.21.0[${PYTHON_USEDEP}]
	>=dev-python/importlib-metadata-8.4.0[${PYTHON_USEDEP}]
	<dev-python/importlib-metadata-9.0.0[${PYTHON_USEDEP}]
	>=dev-python/virtualenv-20.0.35[${PYTHON_USEDEP}]
	dev-python/shellingham[${PYTHON_USEDEP}]
	dev-python/tomlkit[${PYTHON_USEDEP}]
	scan? (
		dev-python/safety[${PYTHON_USEDEP}]
	)
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
	distutils-r1_src_prepare

	local pkgName
	local jobs=$(makeopts_jobs)
	local packages=( click click_didyoumean dotenv
					 pexpect pep517 pipdeptree plette ptyprocess pyparsing pythonfinder
					 shellingham tomli tomlkit importlib_metadata )
	for pkgName in ${packages[@]}; do
		find ./ -type f -print0 | \
			xargs --max-procs="${jobs}" --null \
			sed --in-place \
				-e "s/from pipenv.vendor import ${pkgName}/import ${pkgName}/g" \
				-e "s/from pipenv.vendor.${pkgName}\(.*\) import \(\w*\)/from ${pkgName}\1 import \2/g"\
				-e "s/import pipenv.vendor.${pkgName} as ${pkgName}/import ${pkgName}/g" \
				-e "s/from .vendor import ${pkgName}/import ${pkgName}/g" \
		        -e "s/from .vendor.${pkgName}/from ${pkgName}/g" || die "Failed to sed for ${pkgName}"
	done


	# remove vendored versions
	for pkgName in ${packages[@]}; do
		find  ./pipenv/vendor -regextype posix-extended -regex ".*${pkgName}$" -prune -exec rm -rv {} + || die
		# package names can be foo-bar, their module will be however foo_bar
		find  ./pipenv/vendor -regextype posix-extended -regex ".*${pkgName/_/-}" -prune -exec rm -rv {} + || die
	done

	for fname in Makefile README.md vendor.txt; do
		rm -v pipenv/vendor/"${fname}" || die "Failed removing pipenv/vendor/${fname}"
	done

	sed --in-place -e "s/pipenv.vendor.pythonfinder.utils.get_python_version/pythonfinder.utils.get_python_version/g" tests/unit/test_utils.py || die "Failed patching tests"

	rm -Rv pipenv/vendor || die "Could not vendor"
	rm -Rv examples || die "Could not remove examples"
	rm -Rv docs || die "Could not remove docs"
}

python_test() {
	epytest -m "not cli and not needs_internet" tests/unit/
}

pkg_postinst() {
	optfeature "enabling the check subcommand" dev-python/safety
	optfeature "enabling the scan subcommand" dev-python/safety
}
