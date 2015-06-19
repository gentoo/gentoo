# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/jemalloc/jemalloc-3.6.0.ebuild,v 1.11 2014/12/28 11:56:01 blueness Exp $

EAPI=5

inherit autotools-multilib eutils flag-o-matic

DESCRIPTION="Jemalloc is a general-purpose scalable concurrent allocator"
HOMEPAGE="http://www.canonware.com/jemalloc/"
SRC_URI="http://www.canonware.com/download/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="debug static-libs stats"
HTML_DOCS=( doc/jemalloc.html )
PATCHES=( "${FILESDIR}/${PN}-3.5.1-strip-optimization.patch"
	"${FILESDIR}/${PN}-3.5.1-no-pprof.patch"
	"${FILESDIR}/${PN}-3.5.1_fix_html_install.patch"
)
MULTILIB_WRAPPED_HEADERS=( /usr/include/jemalloc/jemalloc.h )
# autotools-utils.eclass auto-adds configure options when static-libs is in IUSE
# but jemalloc doesn't implement them in its configure; need this here to
# supress the warnings until automagic is removed from the eclass
QA_CONFIGURE_OPTIONS="--enable-static --disable-static --enable-shared --disable-shared"
src_configure() {
	myeconfargs=(
		$(use_enable debug)
		$(use_enable stats)
	)
	use sparc && append-cppflags -DLG_QUANTUM=4 -mcpu=ultrasparc
	autotools-multilib_src_configure
}

src_install() {
	autotools-multilib_src_install

	if [[ ${CHOST} == *-darwin* ]] ; then
		# fixup install_name, #437362
		install_name_tool \
			-id "${EPREFIX}"/usr/$(get_libdir)/libjemalloc.1.dylib \
			"${ED}"/usr/$(get_libdir)/libjemalloc.1.dylib || die
	fi
	use static-libs || find "${ED}" -name '*.a' -delete
}
