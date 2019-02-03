# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools eutils

DESCRIPTION="A high-performance MongoDB driver for C"
HOMEPAGE="https://github.com/mongodb/mongo-c-driver"
SRC_URI="https://github.com/mongodb/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
IUSE="debug examples libressl sasl ssl static-libs test"

RDEPEND=">=dev-libs/libbson-1.1.10
	sasl? ( dev-libs/cyrus-sasl )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)"
DEPEND="${RDEPEND}
	test? ( dev-db/mongodb )"

DOCS=( NEWS README.rst TUTORIAL.md )

# No tests on x86 because tests require dev-db/mongodb which don't support
# x86 anymore (bug #645994)
RESTRICT="x86? ( test )"

src_prepare() {
	rm -r src/libbson || die
	sed -i -e '/SUBDIRS/s:src/libbson::g' Makefile.am || die

	# https://github.com/mongodb/mongo-c-driver/issues/54
	sed -i -e "s/PTHREAD_LIBS/PTHREAD_CFLAGS/g" src/Makefile.am \
		tests/Makefile.am || die
	eautoreconf
}

src_configure() {
	econf --with-libbson=system \
		--disable-hardening \
		--disable-optimizations \
		--disable-examples \
		$(use_enable sasl) \
		$(use_enable ssl) \
		$(use_enable debug) \
		$(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" install
	doman doc/*.3

	use static-libs || find "${D}" -name '*.la' -delete

	if use examples; then
		insinto /usr/share/${PF}/examples
		doins -r examples/*.c examples/aggregation examples/bulk
	fi
}

src_test() {
	# Avoid allocating too much disk space by using server.smallFiles = 1
	echo -e "storage:\n    smallFiles: true" > "${T}/mongod.conf"
	local PORT=27099
	mongod --port ${PORT} --bind_ip 127.0.0.1 --nounixsocket --fork \
		-f "${T}/mongod.conf" --dbpath="${T}" \
		--logpath="${T}/mongod.log" || die
	MONGOC_TEST_HOST="127.0.0.1:${PORT}" emake test
	kill `cat "${T}/mongod.lock"`
}
