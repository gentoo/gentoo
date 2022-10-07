# Copyright 2017-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# don't forget to add itoa-0.3.4 for tests https://bugs.gentoo.org/803512
CRATES="
"

inherit cargo optfeature systemd

DESCRIPTION="ccache/distcc like tool with support for rust and cloud storage"
HOMEPAGE="https://github.com/mozilla/sccache/"

if [ ${PV} == "9999" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mozilla/sccache.git"
else
	SRC_URI="https://github.com/mozilla/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"
	KEYWORDS="~amd64 ~ppc64"
fi

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD BSD-2 Boost-1.0 ISC MIT Unlicense ZLIB"
SLOT="0"
IUSE="azure dist-client dist-server gcs memcached redis s3 simple-s3"
REQUIRED_USE="s3? ( simple-s3 )"

BDEPEND="virtual/pkgconfig"

DEPEND="
	sys-libs/zlib:=
	app-arch/zstd
	dist-server? ( dev-libs/openssl:0= )
	gcs? ( dev-libs/openssl:0= )
"

RDEPEND="${DEPEND}
	dist-server? ( sys-apps/bubblewrap )
"

QA_FLAGS_IGNORED="usr/bin/sccache*"

src_unpack() {
	if [[ "${PV}" == *9999* ]]; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
	fi
}

src_configure() {
	myfeatures=(
		native-zlib
		$(usev azure)
		$(usev dist-client)
		$(usev dist-server)
		$(usev gcs)
		$(usev memcached)
		$(usev redis)
		$(usev s3)
		$(usev simple-s3)
	)
	cargo_src_configure --no-default-features
}

src_install() {
	cargo_src_install

	keepdir /etc/sccache

	einstalldocs
	dodoc -r docs/.

	if use dist-server; then
		newinitd "${FILESDIR}"/server.initd sccache-server
		newconfd "${FILESDIR}"/server.confd sccache-server

		newinitd "${FILESDIR}"/scheduler.initd sccache-scheduler
		newconfd "${FILESDIR}"/scheduler.confd sccache-scheduler

		systemd_dounit "${FILESDIR}"/sccache-server.service
		systemd_dounit "${FILESDIR}"/sccache-scheduler.service

	fi
}

src_test() {
	if [[ "${PV}" == *9999* ]]; then
		ewarn "tests are always broken for ${PV} (require network), skipping"
	else
		cargo_src_test
	fi
}

pkg_postinst() {
	ewarn "${PN} is experimental, please use with care"
	use memcached && optfeature "memcached backend support" net-misc/memcached
	use redis && optfeature "redis backend support" dev-db/redis
}
