# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic user

DESCRIPTION="Sagan is a multi-threaded, real time system and event log monitoring system"
HOMEPAGE="http://sagan.quadrantsec.com/"
SRC_URI="http://sagan.quadrantsec.com/download/sagan-1.0.0RC3.tar.gz"
S="${WORKDIR}/sagan-1.0.0RC3/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="geoip +libdnet +lognorm mysql +pcap smtp snort"

BDEPEND="virtual/pkgconfig"
RDEPEND="
	app-admin/sagan-rules[lognorm?]
	dev-libs/libpcre
	geoip? ( dev-libs/geoip )
	lognorm? (
		dev-libs/liblognorm
		dev-libs/json-c:=
		dev-libs/libee
		dev-libs/libestr
	)
	libdnet? ( dev-libs/libdnet )
	pcap? ( net-libs/libpcap )
	smtp? ( net-libs/libesmtp )
	snort? ( >=net-analyzer/snortsam-2.50 )
"
DEPEND="${RDEPEND}"

# Package no longer logs directly to a database
# and relies on Unified2 format to accomplish it
RDEPEND="${RDEPEND} mysql? ( net-analyzer/barnyard2[mysql] )"

REQUIRED_USE="mysql? ( libdnet )"

DOCS=( AUTHORS ChangeLog FAQ INSTALL README NEWS TODO )

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.0-liblognorm-json-c.patch
)

pkg_setup() {
	enewgroup sagan
	enewuser sagan -1 -1 /dev/null sagan
}

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	append-flags -fcommon

	local myeconfargs=(
		$(use_enable smtp esmtp)
		$(use_enable lognorm)
		$(use_enable libdnet)
		$(use_enable pcap libpcap)
		$(use_enable snort snortsam)
		$(use_enable geoip)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	diropts -g sagan -o sagan -m 775

	dodir /var/log/sagan

	keepdir /var/log/sagan

	touch "${ED}"/var/log/sagan/sagan.log || die
	chown sagan.sagan "${ED}"/var/log/sagan/sagan.log || die

	newinitd "${FILESDIR}"/sagan.init-r1 sagan
	newconfd "${FILESDIR}"/sagan.confd sagan

	docinto examples
	dodoc -r extra/*
}

pkg_postinst() {
	if use smtp; then
		ewarn "You have enabled smtp use flag. If you plan on using Sagan with"
		ewarn "email, create valid writable home directory for user 'sagan'"
		ewarn "For security reasons it was created with /dev/null home directory"
	fi

	einfo "For configuration assistance see"
	einfo "http://wiki.quadrantsec.com/bin/view/Main/SaganHOWTO"
}
