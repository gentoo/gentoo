# Copyright 1999-2022 Gentoo Authors
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

IUSE="+bgp-bins +bmp-bins geoip geoipv2 jansson kafka +l2 mysql ndpi nflog postgres rabbitmq sqlite +st-bins +traffic-bins zmq"

REQUIRED_USE="
	?? ( geoip geoipv2 )
	kafka? ( jansson )
	rabbitmq? ( jansson )
"

RDEPEND="dev-libs/libcdada
	net-libs/libpcap
	geoip? ( dev-libs/geoip )
	geoipv2? ( dev-libs/libmaxminddb )
	jansson? ( dev-libs/jansson:= )
	kafka? ( dev-libs/librdkafka )
	mysql? (
		dev-db/mysql-connector-c:0=
		sys-process/numactl
	)
	ndpi? ( >=net-libs/nDPI-3.2:= )
	nflog? ( net-libs/libnetfilter_log )
	postgres? ( dev-db/postgresql:* )
	rabbitmq? ( net-libs/rabbitmq-c )
	sqlite? ( =dev-db/sqlite-3* )
	zmq? ( >=net-libs/zeromq-4.2.0:= )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-1.7.4--Werror.patch"
	"${FILESDIR}/${PN}-1.7.6-nogit.patch"
)

DOCS=(
	CONFIG-KEYS ChangeLog FAQS QUICKSTART UPGRADE
	docs/INTERNALS docs/PLUGINS docs/SIGNALS
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	tc-export CC AR RANLIB

	local myeconfargs=(
		$(use_enable bgp-bins)
		$(use_enable bmp-bins)
		$(use_enable geoip)
		$(use_enable geoipv2)
		$(use_enable jansson)
		$(use_enable kafka)
		$(use_enable l2)
		$(use_enable mysql)
		$(use_enable ndpi)
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
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	local dirname
	for dirname in examples sql telemetry; do
		docinto ${dirname}
		dodoc -r ${dirname}/*
	done

	newinitd "${FILESDIR}"/pmacctd-init.d pmacctd
	newconfd "${FILESDIR}"/pmacctd-conf.d pmacctd

	systemd_dounit "${FILESDIR}"/{nfacctd,pmacctd,sfacctd}.service

	insinto /etc/pmacctd
	newins examples/pmacctd-imt.conf.example pmacctd.conf
}
