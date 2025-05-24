# Copyright 2025 Gentoo Authors
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
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/uv-${PV}
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
		requires = []
		build-backend = "uv_build"
		backend-path = ["src"]
	EOF

	# rename to make uv-build find it
	mv python src || die
}
