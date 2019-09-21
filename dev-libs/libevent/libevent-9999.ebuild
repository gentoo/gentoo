# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools git-r3 multilib-minimal

DESCRIPTION="Library to execute a function when a specific event occurs on a file descriptor"
EGIT_REPO_URI="https://github.com/libevent/libevent"
HOMEPAGE="
	https://libevent.org/
	${EGIT_REPO_URI}
"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="debug libressl +ssl static-libs test +threads"
RESTRICT="test"

DEPEND="
	ssl? (
		!libressl? ( >=dev-libs/openssl-1.0.1h-r2:0=[${MULTILIB_USEDEP}] )
		libressl? ( dev-libs/libressl:0=[${MULTILIB_USEDEP}] )
	)
"
RDEPEND="
	${DEPEND}
	!<=dev-libs/9libs-1.0
"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/event2/event-config.h
)
DOCS=(
	ChangeLog{,-1.4,-2.0}
)

src_prepare() {
	default
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

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}
