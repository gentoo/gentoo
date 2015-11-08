# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils git-r3 libtool multilib-minimal

DESCRIPTION="A library to execute a function when a specific event occurs on a file descriptor"
HOMEPAGE="http://libevent.org/"
EGIT_REPO_URI="https://github.com/libevent/libevent"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="debug libressl +ssl static-libs test +threads"

DEPEND="
	ssl? (
		!libressl? ( >=dev-libs/openssl-1.0.1h-r2:0[${MULTILIB_USEDEP}] )
		libressl? ( dev-libs/libressl[${MULTILIB_USEDEP}] )
	)"
RDEPEND="
	${DEPEND}
	!<=dev-libs/9libs-1.0
"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/event2/event-config.h
)

src_prepare() {
	eautoreconf
}

multilib_src_configure() {
	# fix out-of-source builds
	mkdir -p test || die

	ECONF_SOURCE="${S}" \
	econf \
		--disable-samples \
		$(use_enable debug debug-mode) \
		$(use_enable debug malloc-replacement) \
		$(use_enable ssl openssl) \
		$(use_enable static-libs static) \
		$(use_enable test libevent-regress) \
		$(use_enable threads thread-support)
}

src_test() {
	# The test suite doesn't quite work (see bug #406801 for the latest
	# installment in a riveting series of reports).
	:
	# emake -C test check | tee "${T}"/tests
}

DOCS=( ChangeLog{,-1.4,-2.0} )

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files
}
