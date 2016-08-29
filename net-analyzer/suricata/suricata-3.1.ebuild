# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils user

DESCRIPTION="High performance Network IDS, IPS and Network Security Monitoring engine"
HOMEPAGE="http://suricata-ids.org/"
SRC_URI="http://www.openinfosecfoundation.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+af-packet control-socket cuda debug +detection geoip hardened lua luajit nflog +nfqueue redis +rules test"

DEPEND="
	>=dev-libs/jansson-2.2
	dev-libs/libpcre
	dev-libs/libyaml
	net-libs/libnet:*
	net-libs/libnfnetlink
	dev-libs/nspr
	dev-libs/nss
	>=net-libs/libhtp-0.5.18
	net-libs/libpcap
	sys-apps/file
	cuda?       ( dev-util/nvidia-cuda-toolkit )
	geoip?      ( dev-libs/geoip )
	lua?        ( dev-lang/lua:* )
	luajit?     ( dev-lang/luajit:* )
	nflog?      ( net-libs/libnetfilter_log )
	nfqueue?    ( net-libs/libnetfilter_queue )
	redis?      ( dev-libs/hiredis )
"
# #446814
#	prelude?    ( dev-libs/libprelude )
#	pfring?     ( sys-process/numactl net-libs/pf_ring)
RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/${PN} "${PN}"
}

src_prepare() {
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		"--localstatedir=/var/" \
		"--enable-non-bundled-htp" \
		$(use_enable af-packet) \
		$(use_enable detection) \
		$(use_enable nfqueue) \
		$(use_enable test coccinelle) \
		$(use_enable test unittests) \
		$(use_enable control-socket unix-socket)
	)

	if use cuda ; then
		myeconfargs+=( $(use_enable cuda) )
	fi
	if use debug ; then
		myeconfargs+=( $(use_enable debug) )
	fi
	if use geoip ; then
		myeconfargs+=( $(use_enable geoip) )
	fi
	if use hardened ; then
		myeconfargs+=( $(use_enable hardened gccprotect) )
	fi
	if use nflog ; then
		myeconfargs+=( $(use_enable nflog) )
	fi
	if use redis ; then
		myeconfargs+=( $(use_enable redis hiredis) )
	fi
	# not supported yet (no pfring in portage)
# 	if use pfring ; then
# 		myeconfargs+=( $(use_enable pfring) )
# 	fi
	# no libprelude in portage
# 	if use prelude ; then
# 		myeconfargs+=( $(use_enable prelude) )
# 	fi
	if use lua ; then
		myeconfargs+=( $(use_enable lua) )
	fi
	if use luajit ; then
		myeconfargs+=( $(use_enable luajit) )
	fi

# this should be used when pf_ring use flag support will be added
# 	LIBS+="-lrt -lnuma"

	econf LIBS="${LIBS}" ${myeconfargs[@]}
}

src_install() {
	emake DESTDIR="${D}" install

	insinto "/etc/${PN}"
	doins {classification,reference,threshold}.config suricata.yaml

	if use rules ; then
		insinto "/etc/${PN}/rules"
		doins rules/*.rules
	fi

	dodir "/var/lib/${PN}"
	dodir "/var/log/${PN}"
	fowners -R ${PN}: "/var/lib/${PN}" "/var/log/${PN}" "/etc/${PN}"
	fperms 750 "/var/lib/${PN}" "/var/log/${PN}" "/etc/${PN}"
}
