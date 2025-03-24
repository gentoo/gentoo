# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
# maturin compiles uv-build executable for every impl, we do not want
# that, so we hack hatchling into installing the Python module instead.
DISTUTILS_UPSTREAM_PEP517=maturin
PYTHON_COMPAT=( pypy3 pypy3_11 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="PEP517 uv build backend"
HOMEPAGE="
	https://github.com/astral-sh/uv/
	https://pypi.org/project/uv-build/
"

LICENSE="|| ( Apache-2.0 MIT )"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/uv-${PV}
"

src_prepare() {
	local PATCHES=(
		# use 'uv build-backend' instead of compiling uv-build executable
		# that largely overlaps with dev-python/uv
		"${FILESDIR}/${PN}-0.6.9-use-uv.patch"
	)

	distutils-r1_src_prepare

	cat >> pyproject.toml <<-EOF || die
		[tool.hatch.build.targets.wheel]
		packages = ["python/uv_build"]
	EOF
}
