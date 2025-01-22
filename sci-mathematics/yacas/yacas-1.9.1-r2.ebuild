# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Sphinx doc building is not compatible with in-tree version of sphinx-bibtex:
# Extension error: You must configure the bibtex_bibfiles setting
#
# PYTHON_COMPAT=( python3_{8..10} )
# DOCS_BUILDER="sphinx"
# DOCS_DEPEND="
# 	dev-python/sphinxcontrib-bibtex
# 	dev-python/sphinx-rtd-theme
# "

inherit cmake xdg # python-any-r1 docs

DESCRIPTION="General purpose computer algebra system"
HOMEPAGE="https://www.yacas.org/"
SRC_URI="https://github.com/grzegorzmazur/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/1"
KEYWORDS="~amd64 ~x86"
IUSE="+jupyter test"
RESTRICT="!test? ( test )"

# Upstream bundles MathJax-2.x
DEPEND="
	jupyter? (
		dev-libs/boost:=
		dev-libs/jsoncpp:=
		dev-libs/openssl:0=
		dev-python/jupyter
		net-libs/zeromq
		>=net-libs/zmqpp-4.1.2
	)
"
RDEPEND="${DEPEND}"

src_configure() {
	# TODO: Unbundle CodeMirror
	local mycmakeargs=(
		-DENABLE_CYACAS_BENCHMARKS=OFF
		-DENABLE_DOCS=OFF
		# -DENABLE_DOCS=$(usex doc)
		-DENABLE_JYACAS=OFF # requires manual install
		-DENABLE_CYACAS_GUI=OFF # bug 926677
		# use system version of mathjax instead
		-DENABLE_CYACAS_GUI_PRIVATE_MATHJAX=OFF
		-DMATHJAX_PATH="${EPREFIX}/usr/share/mathjax/MathJax.js"
		-DENABLE_CYACAS_KERNEL=$(usex jupyter)
		-DENABLE_CYACAS_UNIT_TESTS=$(usex test)
	)
	cmake_src_configure
}
