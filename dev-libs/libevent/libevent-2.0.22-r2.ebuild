# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils libtool multilib-minimal

MY_P="${P}-stable"

DESCRIPTION="Library to execute a function when a specific event occurs on a file descriptor"
HOMEPAGE="http://libevent.org/"
SRC_URI="mirror://sourceforge/levent/files/${MY_P}.tar.gz"

LICENSE="BSD"
# libevent-2.0.so.5
SLOT="0/2.0-5"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="debug libressl +ssl static-libs test +threads"

DEPEND="
	ssl? (
		!libressl? ( >=dev-libs/openssl-1.0.1h-r2[${MULTILIB_USEDEP}] )
		libressl? ( dev-libs/libressl[${MULTILIB_USEDEP}] )
	)
"
RDEPEND="
	${DEPEND}
	!<=dev-libs/9libs-1.0
"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/event2/event-config.h
)

S=${WORKDIR}/${MY_P}

DOCS=( README ChangeLog )

src_prepare() {
	elibtoolize

	# don't waste time building tests/samples
	# https://github.com/libevent/libevent/pull/143
	# https://github.com/libevent/libevent/pull/144
	sed -i \
		-e 's|^\(SUBDIRS =.*\)sample test\(.*\)$|\1\2|' \
		Makefile.in || die "sed Makefile.in failed"
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" \
	econf \
		$(use_enable debug debug-mode) \
		$(use_enable debug malloc-replacement) \
		$(use_enable ssl openssl) \
		$(use_enable static-libs static) \
		$(use_enable threads thread-support)
}

src_test() {
	# The test suite doesn't quite work (see bug #406801 for the latest
	# installment in a riveting series of reports).
	:
	# emake -C test check | tee "${T}"/tests
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files
}
