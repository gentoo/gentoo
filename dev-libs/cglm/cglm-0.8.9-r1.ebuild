# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOCS_BUILDER="sphinx"
DOCS_AUTODOC=1
DOCS_DEPEND="dev-python/sphinx-rtd-theme"
DOCS_DIR="${S}/docs/source"

PYTHON_COMPAT=( python3_{9..11} )
inherit python-any-r1 docs meson

DESCRIPTION="OpenGL Mathematics (glm) for C"
HOMEPAGE="https://github.com/recp/cglm"
SRC_URI="https://github.com/recp/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc64 ~x86"
IUSE="test"

RESTRICT="!test? ( test )"

src_prepare() {
	default
	# DOCS_DEPEND needs DOCS_AUTODOC which needs the extension
	sed -i -e "/^extensions/s/$/ 'sphinx.ext.autodoc',/" docs/source/conf.py || die
}
src_configure() {
	local emesonargs=(
		$(meson_use test build_tests)
	)
	meson_src_configure
}

src_compile() {
	meson_src_compile
	docs_compile
}
