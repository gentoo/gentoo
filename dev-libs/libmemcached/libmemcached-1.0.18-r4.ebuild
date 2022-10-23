# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="a C client library to the memcached server"
HOMEPAGE="https://libmemcached.org/libMemcached.html"
SRC_URI="https://launchpad.net/${PN}/$(ver_cut 1-2)/${PV}/+download/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="debug hsieh +libevent sasl"
# https://bugs.gentoo.org/498250
# https://bugs.launchpad.net/gentoo/+bug/1278023
RESTRICT="test"

RDEPEND="
	net-misc/memcached
	sasl? ( dev-libs/cyrus-sasl )
	libevent? ( dev-libs/libevent )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/debug-disable-enable-1.0.18.patch
	"${FILESDIR}"/continuum-1.0.18.patch
	"${FILESDIR}"/${P}-gcc7.patch
	"${FILESDIR}"/${P}-autotools.patch
	"${FILESDIR}"/${P}-disable-sphinx.patch
	"${FILESDIR}"/${P}-musl.patch
)

src_prepare() {
	default
	rm README.win32 || die
	eautoreconf
}

src_configure() {
	econf \
		--disable-dtrace \
		$(use_enable sasl sasl) \
		$(use_enable debug debug) \
		$(use_enable debug assert) \
		$(use_enable hsieh hsieh_hash)
}

src_install() {
	default

	# https://bugs.gentoo.org/299330
	# remove manpage to avoid collision
	rm -f "${ED}"/usr/share/man/man1/memdump.* || die
	newman man/memdump.1 memcached_memdump.1

	find "${ED}" -name '*.la' -delete || die
}
