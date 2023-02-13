# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools git-r3 multilib-minimal

DESCRIPTION="Library to execute a function when a specific event occurs on a file descriptor"
EGIT_REPO_URI="https://github.com/libevent/libevent"
HOMEPAGE="
	https://libevent.org/
	https://github.com/libevent/libevent
"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="
	+clock-gettime debug malloc-replacement mbedtls +ssl static-libs
	test verbose-debug
"
RESTRICT="test"

DEPEND="
	mbedtls? ( net-libs/mbedtls )
	ssl? (
		>=dev-libs/openssl-1.0.1h-r2:0=[${MULTILIB_USEDEP}]
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
		$(use_enable clock-gettime) \
		$(use_enable debug debug-mode) \
		$(use_enable malloc-replacement malloc-replacement) \
		$(use_enable mbedtls) \
		$(use_enable ssl openssl) \
		$(use_enable static-libs static) \
		$(use_enable test libevent-regress) \
		$(use_enable verbose-debug) \
		--disable-samples
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}
