# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYPI_PN=${PN#ensurepip-}
# PYTHON_COMPAT used only for testing
PYTHON_COMPAT=( python3_{11..14} python3_{13,14}t pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Shared wheel wheel for use in pip tests"
HOMEPAGE="
	https://github.com/pypa/wheel/
	https://pypi.org/project/wheel/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

BDEPEND="
	test? (
		dev-python/setuptools[${PYTHON_USEDEP}]
	)
"

# xdist is slightly flaky here
EPYTEST_PLUGINS=( pytest-rerunfailures )
EPYTEST_XDIST=1
distutils_enable_tests pytest

PATCHES=(
	# https://github.com/pypa/wheel/pull/651
	"${FILESDIR}/wheel-0.45.1-test.patch"
)

declare -A VENDOR_LICENSES=(
	[packaging]="|| ( Apache-2.0 MIT )"
)
LICENSE+=" ${VENDOR_LICENSES[*]}"

src_prepare() {
	distutils-r1_src_prepare

	# Verify that we've covered licenses for all vendored packages
	cd src/wheel/vendored || die
	local packages=( */ )
	local pkg missing=()
	for pkg in "${packages[@]%/}"; do
		if [[ ! -v "VENDOR_LICENSES[${pkg}]" ]]; then
			missing+=( "${pkg}" )
		else
			unset "VENDOR_LICENSES[${pkg}]"
		fi
	done

	if [[ ${missing[@]} || ${VENDOR_LICENSES[@]} ]]; then
		[[ ${missing[@]} ]] &&
			eerror "License missing for packages: ${missing[*]}"
		[[ ${VENDOR_LICENSES[@]} ]] &&
			eerror "Vendored packages removed: ${!VENDOR_LICENSES[*]}"
		die "VENDOR_LICENSES outdated"
	fi

	local upstream_count=$(wc -l < vendor.txt || die)
	if [[ ${#packages[@]} -ne ${upstream_count} ]]; then
		eerror "VENDOR_LICENSES: ${#packages[@]}"
		eerror "vendor.txt:      ${upstream_count}"
		die "Not all vendored packages matched"
	fi
}

python_compile() {
	# If we're testing, install for all implementations.
	# If we're not, just get one wheel built.
	if use test || [[ -z ${DISTUTILS_WHEEL_PATH} ]]; then
		distutils-r1_python_compile
	fi
}

python_test() {
	local EPYTEST_DESELECT=(
		# fails if any setuptools plugin imported the module first
		tests/test_bdist_wheel.py::test_deprecated_import

		# broken by setuptools license changes
		# upstream removed the tests already
		tests/test_bdist_wheel.py::test_licenses_default
		tests/test_bdist_wheel.py::test_licenses_deprecated
		tests/test_bdist_wheel.py::test_licenses_override
	)

	epytest --reruns=5
}

src_install() {
	if [[ ${DISTUTILS_WHEEL_PATH} != *py3-none-any.whl ]]; then
		die "Non-pure wheel produced?! ${DISTUTILS_WHEEL_PATH}"
	fi
	# TODO: compress it?
	insinto /usr/lib/python/ensurepip
	doins "${DISTUTILS_WHEEL_PATH}"
}
