# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/glog/glog-0.3.3-r1.ebuild,v 1.6 2015/05/01 05:50:04 jer Exp $

EAPI="4"
inherit eutils multilib-minimal

DESCRIPTION="Google's C++ logging library"
HOMEPAGE="http://code.google.com/p/google-glog/"
SRC_URI="http://google-glog.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ppc64 ~s390 ~sh ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="gflags static-libs unwind test"

RDEPEND="gflags? ( >=dev-cpp/gflags-2.0-r1[${MULTILIB_USEDEP}] )
	unwind? ( sys-libs/libunwind )"
DEPEND="${RDEPEND}
	test? (
		>=dev-cpp/gmock-1.7.0-r1[${MULTILIB_USEDEP}]
		>=dev-cpp/gtest-1.6.0-r2[${MULTILIB_USEDEP}]
	)"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.3.2-avoid-inline-asm.patch
	# Fix the --dodcdir flag:
	# https://code.google.com/p/google-glog/issues/detail?id=193
	sed -i \
		-e '/^docdir =/s:=.*:= @docdir@:' \
		Makefile.in || die
}

multilib_src_configure() {
	use test || export ac_cv_prog_GTEST_CONFIG=no
	ECONF_SOURCE=${S} \
	ac_cv_lib_gflags_main=$(usex gflags) \
	ac_cv_lib_unwind_backtrace=$(usex unwind) \
	econf \
		--docdir="\$(datarootdir)/doc/${PF}" \
		--htmldir='$(docdir)/html' \
		$(use_enable static-libs static)
}

_emake() {
	# The tests always get built ... disable them when unused.
	emake $(usex test '' noinst_PROGRAMS=) "$@"
}

multilib_src_compile() {
	_emake
}

multilib_src_install() {
	_emake install DESTDIR="${D}"
}

multilib_src_install_all() {
	# Punt docs we don't care about (NEWS is 0 bytes).
	rm "${ED}"/usr/share/doc/${PF}/{COPYING,NEWS,README.windows} || die

	# --htmldir doesn't work (yet):
	# https://code.google.com/p/google-glog/issues/detail?id=144
	dohtml "${ED}"/usr/share/doc/${PF}/*
	rm "${ED}"/usr/share/doc/${PF}/*.{html,css}

	use static-libs || find "${ED}" -name '*.la' -delete
}
