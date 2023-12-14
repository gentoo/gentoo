# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} pypy3 )
inherit python-single-r1

DESCRIPTION="A command-line tool and library to read and convert trace files"
HOMEPAGE="https://babeltrace.org/"
SRC_URI="https://www.efficios.com/files/${PN}/${PN}$(ver_cut 1)-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0/$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="doc +elfutils +man plugins python"
REQUIRED_USE="plugins? ( python ) python? ( ${PYTHON_REQUIRED_USE} )"
S="${WORKDIR}/${PN}$(ver_cut 1)-${PV}"

RDEPEND=">=dev-libs/glib-2.28:2
	elfutils? ( >=dev-libs/elfutils-0.154 )
	python? ( ${PYTHON_DEPS} )
"

BDEPEND="${RDEPEND}
	>=sys-devel/bison-2.5
	>=sys-devel/flex-2.5.35
	python? (
		>=dev-lang/swig-3.0
		$(python_gen_cond_dep 'dev-python/setuptools[${PYTHON_USEDEP}]' python3_12)
		doc? ( >=dev-python/sphinx-1.3 )
	)
	doc? ( >=app-doc/doxygen-1.8.6 )
	man? (
		>=app-text/asciidoc-8.6.8
		>=app-text/xmlto-0.0.25
	)
"

src_configure() {
	use python && export PYTHON_CONFIG="${EPYTHON}-config"
	econf \
		$(use_enable doc api-doc) \
		$(use_enable elfutils debug-info) \
		$(use_enable man man-pages) \
		$(use_enable python python-bindings) \
		$(usex python $(use_enable doc python-bindings-doc) --disable-python-bindings-doc) \
		$(use_enable plugins python-plugins) \
		--disable-built-in-plugins \
		--disable-built-in-python-plugin-support
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
