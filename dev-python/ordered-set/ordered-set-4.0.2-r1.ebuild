# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 7 -- sys-apps/portage dep
EAPI=7

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{8..10} pypy3 )
inherit distutils-r1

DESCRIPTION="A mutable set that remembers the order of its entries"
HOMEPAGE="https://github.com/rspeer/ordered-set"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

distutils_enable_tests pytest

src_configure() {
	[[ -e pyproject.toml ]] &&
		die "Upstream added pyproject.toml, recheck"
	# write a custom pyproject.toml to ease setuptools bootstrap
	cat > pyproject.toml <<-EOF || die
		[build-system]
		requires = ["flit_core >=3.2,<4"]
		build-backend = "flit_core.buildapi"

		[project]
		name = "ordered-set"
		dynamic = ["version", "description"]

		[tool.flit.module]
		name = "ordered_set"
	EOF
}
