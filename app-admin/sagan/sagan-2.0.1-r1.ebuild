# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic systemd

DESCRIPTION="Sagan is a multi-threaded, real time system and event log monitoring system"
HOMEPAGE="https://sagan.quadrantsec.com/"
SRC_URI="https://sagan.quadrantsec.com/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="geoip +libdnet +lognorm mysql redis +pcap smtp"

BDEPEND="virtual/pkgconfig"
DEPEND="
	app-admin/sagan-rules[lognorm?]
	acct-user/sagan
	acct-group/sagan
	dev-libs/libpcre
	dev-libs/libyaml
	geoip? ( dev-libs/geoip )
	lognorm? (
		dev-libs/liblognorm
		dev-libs/libfastjson:=
		dev-libs/libestr
	)
	redis? ( dev-libs/hiredis )
	pcap? ( net-libs/libpcap )
	smtp? ( net-libs/libesmtp )
"

# Package no longer logs directly to a database
# and relies on Unified2 format to accomplish it
RDEPEND="
	${RDEPEND}
	mysql? ( net-analyzer/barnyard2[mysql] )
"

REQUIRED_USE="mysql? ( libdnet )"

DOCS=( AUTHORS ChangeLog FAQ INSTALL README NEWS TODO )

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	append-flags -fcommon

	# TODO: poke at strstr logic and enable/disable CPU_FLAGS_X86_*
	# accordingly?
	# Note that not all of these are used:
	# https://github.com/quadrantsec/sagan/blob/main/m4/ax_ext.m4
	local myeconfargs=(
		$(use_enable smtp esmtp)
		$(use_enable lognorm)
		$(use_enable redis)
		$(use_enable pcap libpcap)
		$(use_enable geoip)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	# No need to create this at build/install time
	rm -r "${ED}"/var/run/ || die

	# Fix paths in config file
	sed -i -e "s:/usr/local/:${EPREFIX}/:" "${ED}"/etc/sagan.yaml || die

	diropts -g sagan -o sagan -m 775

	dodir /var/log/sagan

	keepdir /var/log/sagan

	touch "${ED}"/var/log/sagan/sagan.log || die
	chown sagan.sagan "${ED}"/var/log/sagan/sagan.log || die

	newinitd "${FILESDIR}"/sagan.init-r1 sagan
	newconfd "${FILESDIR}"/sagan.confd sagan

	systemd_dounit "${FILESDIR}"/sagan.service

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
