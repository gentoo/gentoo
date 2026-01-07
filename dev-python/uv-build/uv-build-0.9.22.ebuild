# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Maturin compiles uv-build executable for every impl, we do not want
# that, so we use another backend.  And since we use another backend,
# why not dogfood it in the first place?
DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="PEP517 uv build backend"
HOMEPAGE="
	https://github.com/astral-sh/uv/
	https://pypi.org/project/uv-build/
"

LICENSE="|| ( Apache-2.0 MIT )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/uv-${PV}
"
BDEPEND="
	test? (
		app-arch/unzip
		dev-python/build[${PYTHON_USEDEP}]
	)
"

src_prepare() {
	distutils-r1_src_prepare

	# use the executable from dev-python/uv instead of building
	# a largely overlapping uv-build executable (at least for now)
	sed -i -e '/USE_UV_EXECUTABLE/s:False:True:' python/uv_build/__init__.py || die

	# replace the build-system section
	sed -i -e '/\[build-system\]/,$d' pyproject.toml || die
	cat >> pyproject.toml <<-EOF || die
		[build-system]
		requires = ["uv_build<9999"]
		build-backend = "uv_build"
		backend-path = ["src"]
	EOF

	# rename to make uv-build find it
	mv python src || die
}

python_test() {
	"${EPYTHON}" -m build -n || die "Self-build failed with ${EPYTHON}"

	local zip_result=$(
		unzip -t "dist/uv_build-${PV}-py3-none-any.whl" || die
	)
	local zip_expected="\
Archive:  dist/uv_build-${PV}-py3-none-any.whl
    testing: uv_build/                OK
    testing: uv_build/__init__.py     OK
    testing: uv_build/__main__.py     OK
    testing: uv_build/py.typed        OK
    testing: uv_build-${PV}.dist-info/   OK
    testing: uv_build-${PV}.dist-info/WHEEL   OK
    testing: uv_build-${PV}.dist-info/METADATA   OK
    testing: uv_build-${PV}.dist-info/RECORD   OK
No errors detected in compressed data of dist/uv_build-${PV}-py3-none-any.whl.\
"
	if [[ ${zip_result} != ${zip_expected} ]]; then
		eerror ".zip result:\n${zip_result}"
		eerror ".zip expected:\n${zip_expected}"
		die ".whl result mismatch"
	fi

	local tar_result=$(
		tar -tf "dist/uv_build-${PV}.tar.gz" || die
	)
	local tar_expected="\
uv_build-${PV}/PKG-INFO
uv_build-${PV}/
uv_build-${PV}/README.md
uv_build-${PV}/pyproject.toml
uv_build-${PV}/src
uv_build-${PV}/src/uv_build
uv_build-${PV}/src/uv_build/__init__.py
uv_build-${PV}/src/uv_build/__main__.py
uv_build-${PV}/src/uv_build/py.typed\
"
	if [[ ${tar_result} != ${tar_expected} ]]; then
		eerror ".tar.gz result:\n${tar_result}"
		eerror ".tar.gz expected:\n${tar_expected}"
		die ".tar.gz result mismatch"
	fi
}
