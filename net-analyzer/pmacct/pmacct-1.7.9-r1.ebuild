# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs systemd

DESCRIPTION="A network tool to gather IP traffic information"
HOMEPAGE="http://www.pmacct.net/"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/pmacct/pmacct"
	inherit git-r3
else
	SRC_URI="https://github.com/pmacct/pmacct/releases/download/v${PV}/${P}.tar.gz
		http://www.pmacct.net/${P}.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"

IUSE="+bgp-bins +bmp-bins geoipv2 jansson kafka +l2 mysql nflog postgres rabbitmq sqlite +st-bins +traffic-bins zmq"

REQUIRED_USE="
	kafka? ( jansson )
	rabbitmq? ( jansson )
"

RDEPEND="dev-libs/libcdada
	net-libs/libpcap
	geoipv2? ( dev-libs/libmaxminddb )
	jansson? ( dev-libs/jansson:= )
	kafka? ( dev-libs/librdkafka )
	mysql? (
		dev-db/mysql-connector-c:0=
		sys-process/numactl
	)
	nflog? ( net-libs/libnetfilter_log )
	postgres? ( dev-db/postgresql:* )
	rabbitmq? ( net-libs/rabbitmq-c )
	sqlite? ( =dev-db/sqlite-3* )
	zmq? ( >=net-libs/zeromq-4.2.0:= )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.7.9-build-system.patch
	"${FILESDIR}"/${PN}-1.7.9-c23.patch
)

DOCS=(
	CONFIG-KEYS ChangeLog FAQS QUICKSTART UPGRADE
	docs/INTERNALS docs/PLUGINS docs/SIGNALS
)

src_prepare() {
	default
	eautoreconf

	# keep a pristine copy, the build leaves objects and binaries in examples/
	cp -r examples "${T}"/examples || die
}

src_configure() {
	tc-export CC AR RANLIB

	local myeconfargs=(
		$(use_enable bgp-bins)
		$(use_enable bmp-bins)
		$(use_enable geoipv2)
		$(use_enable jansson)
		$(use_enable kafka)
		$(use_enable l2)
		$(use_enable mysql)
		$(use_enable nflog)
		$(use_enable postgres pgsql)
		$(use_enable rabbitmq)
		$(use_enable sqlite sqlite3)
		$(use_enable st-bins)
		$(use_enable traffic-bins)
		$(use_enable zmq)

		--without-external-deps
		--disable-ebpf
		--disable-debug
		--disable-mongodb
		# relies on nDPI internals, upstream only supports nDPI 4.14 through
		# a copy of its private header, bug #970106
		# https://github.com/pmacct/pmacct/commit/4cf7ce47cabcc5c452de9ba9b356c52d6eb3fcc6
		--disable-ndpi
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	# only a .la for a static library that isn't installed, bug #848729
	rm -r "${ED}"/usr/$(get_libdir)/pmacct/examples/custom || die

	dodoc -r "${T}"/examples sql

	newinitd "${FILESDIR}"/pmacctd-init.d pmacctd
	newconfd "${FILESDIR}"/pmacctd-conf.d pmacctd

	systemd_dounit "${FILESDIR}"/{nfacctd,pmacctd,sfacctd}.service

	insinto /etc/pmacctd
	newins examples/pmacctd-imt.conf.example pmacctd.conf
}
