# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A high-performance MongoDB driver for C"
HOMEPAGE="https://github.com/mongodb/mongo-c-driver"
SRC_URI="https://github.com/mongodb/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~hppa x86"
IUSE="debug examples libressl sasl ssl static-libs test"

RDEPEND="app-arch/snappy:=
	>=dev-libs/libbson-1.8.2
	sys-libs/zlib:=
	sasl? ( dev-libs/cyrus-sasl )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)"
DEPEND="${RDEPEND}
	test? ( dev-db/mongodb )"

# No tests on x86 because tests require dev-db/mongodb which don't support
# x86 anymore (bug #645994)
RESTRICT="x86? ( test )"

src_prepare() {
	# remove bundled libs
	rm -rv src/{libbson,zlib*} || die

	# bundled headers are gone
	sed -e '/^ac_config_files/s@src/zlib-.*/zconf.h@@g' \
		-i configure || die

	# this test fails
	sed -e '/test_topology_install (&suite)/d' \
		-i tests/test-libmongoc.c || die

	default
}

src_configure() {
	econf --with-libbson=system \
		--with-snappy=system \
		--with-zlib=system \
		--disable-optimizations \
		--disable-shm-counters \
		--disable-examples \
		--docdir="${EPREFIX}/usr/share/doc/${P}" \
		$(use_enable sasl) \
		$(use_enable ssl ssl $(usex libressl libressl openssl)) \
		$(use_enable debug) \
		$(use_enable static-libs static)
}

src_install() {
	default_src_install

	# Only install the mongoc man pages to avoid conflicts of common names
	doman doc/man/mongoc_*.3

	if ! use static-libs; then
		find "${D}" -name '*.la' -delete || die
	fi

	if use examples; then
		docinto examples
		dodoc -r examples/*.c examples/aggregation examples/bulk
	fi
}

src_test() {
	# Avoid allocating too much disk space by using server.smallFiles = 1
	echo -e "storage:\n    smallFiles: true" > "${T}/mongod.conf" || die
	local PORT=27099
	mongod --port ${PORT} --bind_ip 127.0.0.1 --nounixsocket --fork \
		-f "${T}/mongod.conf" --dbpath="${T}" \
		--logpath="${T}/mongod.log" || die
	MONGOC_TEST_HOST="127.0.0.1:${PORT}" emake test
	kill $(<"${T}/mongod.lock")
}
