# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7,8} )
PYTHON_REQ_USE='threads(+)'
inherit python-any-r1 waf-utils multilib-build multilib-minimal

DESCRIPTION="Library for storing RDF data in memory"
HOMEPAGE="http://drobilla.net/software/sord/"
COMMIT="81e138633076c2d7ef7e1691845757208d02f478"
COMMIT_AUTOWAF="6c6c1d29bfe4c28dd26b5cde7ea4a1a148ee700d"
SRC_URI="https://gitlab.com/drobilla/${PN}/-/archive/${COMMIT}/${PN}-${COMMIT}.tar.gz
	https://github.com/drobilla/autowaf/archive/${COMMIT_AUTOWAF}.tar.gz -> drobilla-autowaf-${COMMIT_AUTOWAF}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/libpcre
	>=dev-libs/serd-0.30.0
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig"

S="${WORKDIR}/${PN}-${COMMIT}"

DOCS=( "AUTHORS" "NEWS" "README.md" )

src_prepare() {
	# link in downloaded waf
	rm -r "${S}/waflib" || die
	ln -s "${WORKDIR}/autowaf-${COMMIT_AUTOWAF}" "${S}/waflib" || die

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
