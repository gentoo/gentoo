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
	distutils-r1_src_prepare

	cat >> pyproject.toml <<-EOF || die
		[tool.hatch.build.targets.wheel]
		packages = ["python/uv_build"]
	EOF

	# use the executable from dev-python/uv instead of building
	# a largely overlapping uv-build executable (at least for now)
	sed -i -e '/USE_UV_EXECUTABLE/s:False:True:' python/uv_build/__init__.py || die
}
