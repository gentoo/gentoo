# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

MY_PN=${PN%-booking}
DESCRIPTION="High-performance Graphite front-end, Booking.com fork"
HOMEPAGE="https://github.com/bookingcom/carbonapi"
SRC_URI="https://github.com/bookingcom/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}
	acct-group/carbon
	acct-user/carbon"
BDEPEND=""

src_prepare() {
	export VERSION="gentoo-${PVR}"

	# bug 904051: disable data-race detection, conflicts with
	# go-module's -buildmode=pie
	sed -i -e 's/ -race / /' Makefile || die

	eapply_user
}

src_install() {
	insinto /etc/carbonapi
	doins -r "${S}"/config/*
	dobin carbonapi carbonzipper

	newinitd "${FILESDIR}"/${PN}.initd carbonapi
	newconfd "${FILESDIR}"/${PN}.confd carbonapi
}
