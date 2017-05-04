# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit multilib python-single-r1

DESCRIPTION="Language bindings for Redland"
HOMEPAGE="http://librdf.org/bindings/"
SRC_URI="http://download.librdf.org/source/${P}.tar.gz"

LICENSE="Apache-2.0 GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sparc x86 ~x86-linux ~ppc-macos"
IUSE="lua perl python php ruby"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND=">=dev-libs/redland-1.0.14
	lua? ( >=dev-lang/lua-5.1:0 )
	perl? ( dev-lang/perl:= )
	php? ( dev-lang/php:* )
	python? ( ${PYTHON_DEPS} )
	ruby? ( dev-lang/ruby:* dev-ruby/log4r )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=dev-lang/swig-2
	sys-apps/sed"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	econf \
		$(use_with lua) \
		$(use_with perl) \
		$(use_with python) \
		$(use_with php) \
		$(use_with ruby)
}

src_install() {
	emake DESTDIR="${D}" INSTALLDIRS=vendor luadir=/usr/$(get_libdir)/lua/5.1 install

	if use perl; then
		find "${ED}" -type f -name perllocal.pod -delete
		find "${ED}" -depth -mindepth 1 -type d -empty -delete
	fi
	use python && python_optimize

	dodoc AUTHORS ChangeLog NEWS README TODO
	dohtml {NEWS,README,RELEASE,TODO}.html
}
