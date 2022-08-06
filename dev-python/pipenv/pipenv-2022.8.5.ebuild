# Copyright 1999-2022 Gentoo Authors
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

RDEPEND="
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/cached-property[${PYTHON_USEDEP}]
	>=dev-python/cerberus-1.3.2[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
	>=dev-python/colorama-0.4.4[${PYTHON_USEDEP}]
	>=dev-python/idna-3.2[${PYTHON_USEDEP}]
	dev-python/iso8601[${PYTHON_USEDEP}]
	>=dev-python/pexpect-4.8.0[${PYTHON_USEDEP}]
	dev-python/pip[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.8.2[${PYTHON_USEDEP}]
	>=dev-python/virtualenv-20.0.35[${PYTHON_USEDEP}]
	dev-python/virtualenv-clone[${PYTHON_USEDEP}]
	>=dev-python/requests-2.26.0[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]
	>=dev-python/tomli-2.0.1[${PYTHON_USEDEP}]
	dev-python/tomlkit[${PYTHON_USEDEP}]
	>=dev-python/wheel-0.36.0[${PYTHON_USEDEP}]
	>=dev-python/zipp-3.6.0[${PYTHON_USEDEP}]
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
	local packages=( attr cerberus cached_property click colorama idna importlib_metadata \
					 importlib_resources iso8601 pexpect dateutil pyparsing requests toml tomli tomlkit urllib3 zipp )
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

	# not actually used by pipenv, but included in pipenv
	rm -vR "${S}/${PN}/vendor/wheel/" || die
}

python_test() {
	epytest -m "not cli and not needs_internet" tests/unit/
}
