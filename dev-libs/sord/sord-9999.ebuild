# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
PYTHON_REQ_USE='threads(+)'
inherit python-any-r1 waf-utils multilib-build multilib-minimal git-r3

DESCRIPTION="Library for storing RDF data in memory"
HOMEPAGE="http://drobilla.net/software/sord/"
EGIT_REPO_URI="https://github.com/drobilla/sord.git"

LICENSE="ISC"
SLOT="0"
KEYWORDS=""
IUSE="doc static-libs test"
RESTRICT="!test? ( test )"

BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"
RDEPEND="
	dev-libs/libpcre
	dev-libs/serd
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
"
DOCS=( "AUTHORS" "NEWS" "README.md" )

src_prepare() {
	sed -i -e 's/^.*run_ldconfig/#\0/' wscript || die
	default
	multilib_copy_sources
}

multilib_src_configure() {
	waf-utils_src_configure \
		--docdir=/usr/share/doc/${PF} \
		$(multilib_native_usex doc --docs "") \
		$(usex test --test "") \
		$(usex static-libs --static "")
}

multilib_src_test() {
	./waf test || die
}

multilib_src_compile() {
	waf-utils_src_compile
	default
}

multilib_src_install() {
	waf-utils_src_install
	default
}
