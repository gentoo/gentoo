# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Extensions for Python Markdown."
HOMEPAGE="
	https://github.com/facelessuser/pymdown-extensions
	https://pypi.org/project/pymdown-extensions
"
SRC_URI="https://github.com/facelessuser/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Docs require pymdownx.tabbed which is in master on github atm
# but not in the 6.3.0 release tarballs for some reason

#IUSE="doc"
#REQUIRED_USE="x86? ( !doc )"
#
#BDEPEND="doc? (
#	dev-python/mkdocs-material
#	dev-python/mkdocs-git-revision-date-localized-plugin )"

RDEPEND=">=dev-python/markdown-3.2[${PYTHON_USEDEP}]"

DEPEND="test? ( dev-python/pyyaml[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest

#python_compile_all() {
#	default
#	if use doc; then
#		mkdocs build || die "failed to make docs"
#		HTML_DOCS="site"
#	fi
#}
