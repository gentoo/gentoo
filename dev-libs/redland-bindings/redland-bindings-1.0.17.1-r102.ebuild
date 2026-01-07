# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GENTOO_DEPEND_ON_PERL=no
LUA_COMPAT=( lua5-{1..4} luajit )
PYTHON_COMPAT=( python3_11 )

inherit lua perl-module python-single-r1 autotools

DESCRIPTION="Language bindings for Redland"
HOMEPAGE="https://librdf.org/bindings/"
SRC_URI="https://download.librdf.org/source/${P}.tar.gz"

LICENSE="Apache-2.0 GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ppc ppc64 ~sparc x86"
IUSE="lua perl python ruby test ${GENTOO_PERL_USESTRING}"
REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} )
	python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

BDEPEND="virtual/pkgconfig"

RDEPEND="dev-libs/redland
	lua? ( ${LUA_DEPS} )
	perl? (
		${GENTOO_PERL_DEPSTRING}
		dev-lang/perl:=
	)
	python? ( ${PYTHON_DEPS} )
	ruby? ( dev-lang/ruby:* dev-ruby/log4r )"

DEPEND="${RDEPEND}
	dev-lang/swig
	test? (
		dev-libs/redland[berkdb]
	)"

PATCHES=(
	"${FILESDIR}"/${P}-bool.patch
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default

	eautoreconf

	# As of version 1.0.17.1, out-of-tree builds fail with:
	# "error: redland_wrap.c: No such file or directory",
	# have to copy the sources.
	use lua && lua_copy_sources
}

lua_src_configure() {
	pushd "${BUILD_DIR}" > /dev/null || die

	econf \
		--with-lua="${ELUA}" \
		--without-perl \
		--without-php \
		--without-python \
		--without-ruby

	popd > /dev/null || die
}

src_configure() {
	if use perl || use python || use ruby ; then
		econf \
			$(use_with lua) \
			$(use_with perl) \
			$(use_with python) \
			--without-php \
			$(use_with ruby)
	fi

	if use lua; then
		lua_foreach_impl lua_src_configure
	fi
}

lua_src_compile() {
	pushd "${BUILD_DIR}" > /dev/null || die

	default_src_compile

	popd > /dev/null || die
}

src_compile() {
	if use perl || use python || use ruby ; then
		default
	fi

	if use lua; then
		lua_foreach_impl lua_src_compile
	fi
}

lua_src_test() {
	pushd "${BUILD_DIR}" > /dev/null || die

	default_src_test

	popd > /dev/null || die
}

src_test() {
	if use perl || use python || use ruby ; then
		default
	fi

	if use lua; then
		lua_foreach_impl lua_src_test
	fi
}

lua_src_install() {
	pushd "${BUILD_DIR}" > /dev/null || die

	emake DESTDIR="${D}" INSTALLDIRS=vendor luadir="$(lua_get_cmod_dir)" install

	popd > /dev/null || die
}

src_install() {
	if use perl || use python || use ruby ; then
		emake DESTDIR="${D}" INSTALLDIRS=vendor install
	fi

	if use lua; then
		lua_foreach_impl lua_src_install
	fi

	if use perl; then
		find "${ED}" -type f -name perllocal.pod -delete
		find "${ED}" -depth -mindepth 1 -type d -empty -delete
	fi

	use python && python_optimize

	local DOCS=( AUTHORS ChangeLog NEWS README TODO )
	local HTML_DOCS=( {NEWS,README,RELEASE,TODO}.html )
	einstalldocs
}
