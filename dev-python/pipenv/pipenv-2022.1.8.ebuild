# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1 multiprocessing

MY_PV=${PV/_beta/b}
DESCRIPTION="Python Development Workflow for Humans"
HOMEPAGE="https://github.com/pypa/pipenv https://pypi.org/project/pipenv/"
SRC_URI="https://github.com/pypa/pipenv/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${MY_PV}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/${PN}-${PV//./-}-remove-first-vendor-import.patch"
	)

RDEPEND="
	${PYTHON_DEPS}
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/cached-property[${PYTHON_USEDEP}]
	>=dev-python/cerberus-1.3.2[${PYTHON_USEDEP}]
	>=dev-python/colorama-0.4.4[${PYTHON_USEDEP}]
	dev-python/docopt[${PYTHON_USEDEP}]
	>=dev-python/idna-3.2[${PYTHON_USEDEP}]
	>=dev-python/pexpect-4.8.0[${PYTHON_USEDEP}]
	dev-python/pip[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.8.2[${PYTHON_USEDEP}]
	>=dev-python/virtualenv-20.0.35[${PYTHON_USEDEP}]
	dev-python/virtualenv-clone[${PYTHON_USEDEP}]
	>=dev-python/requests-2.26.0[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]
	>=dev-python/tomli-1.2.2[${PYTHON_USEDEP}]
	<dev-python/tomli-2[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.26.7[${PYTHON_USEDEP}]
	>=dev-python/wheel-0.36.0[${PYTHON_USEDEP}]
	>=dev-python/zipp-3.6.0[${PYTHON_USEDEP}]
"

BDEPEND="
	${RDEPEND}
	test? (
		dev-python/flaky[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
	)
"

# IMPORTANT: The following sed command patches the vendor direcotry
# in the pipenv source. Attempts to simply bump the version of the
# package without checking that it works is likely to fail
# The vendored packages should eventually all be removed
# see: https://bugs.gentoo.org/717666
src_prepare() {

	local jobs=$(makeopts_jobs)
	local packages=( attr cerberus cached_property colorama docopt first idna pexpect dateutil requests \
						toml tomli urllib3 zipp )
	for pkgName in ${packages[@]}; do
		find ./ -type f -print0 | \
			xargs --max-procs="${jobs}" --null \
			sed --in-place \
				-e 's/from pipenv.vendor import '"${pkgName}"'/import '"${pkgName}"'/g' \
				-e 's/from pipenv.vendor.'"${pkgName}"'\(.*\) import \(\w*\)/from '"${pkgName}"'\1 import \2/g' \
				-e 's/import pipenv.vendor.'"${pkgName}"' as '"${pkgName}"'/import '"${pkgName}"'/g' \
				-e 's/from .vendor import '"${pkgName}"'/import '"${pkgName}"'/g'
	done
	assert "Failed to sed sources"

	distutils-r1_src_prepare

	# remove vendored versions
	for pkgName in ${packages[@]}; do
		# remove all packages toml* also catches tomlkit. Remove this when tomlkit is stable
		find ./pipenv/vendor -maxdepth 1 ! -name tomlkit -name "${pkgName}*" -prune -exec rm -rvf {} + || die
		# find ./pipenv/vendor -maxdepth 1 ! -name tomlkit -name "${pkgName}*" -print

		# package names can be foo-bar, their module will be however foo_bar
		find ./pipenv/vendor/ -maxdepth 1 ! -name tomlkit -name "${pkgName/_/-}*" -prune -exec rm -rvf {} + || die

	done

	# not actually used by pipenv, but included in pipenv
	rm -vR "${S}/${PN}/vendor/wheel/" || die
}

python_test() {
	pytest -vvv -x -m "not cli and not needs_internet" tests/unit/ || die
}
