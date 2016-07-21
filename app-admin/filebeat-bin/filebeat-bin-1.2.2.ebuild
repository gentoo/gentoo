# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PN=${PN/-bin/}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Lightweight log shipper for Logstash and Elasticsearch"
HOMEPAGE="https://www.elastic.co/products/beats"
SRC_URI="amd64? ( https://download.elastic.co/beats/${MY_PN}/${MY_P}-x86_64.tar.gz )
	x86? ( https://download.elastic.co/beats/${MY_PN}/${MY_P}-i686.tar.gz )"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

QA_PREBUILT="usr/bin/filebeat"

src_unpack() {
	if use amd64; then
		S="${WORKDIR}/${MY_P}-x86_64"
	elif use x86; then
		S="${WORKDIR}/${MY_P}-i686"
	fi

	default
}

src_install() {
	keepdir /etc/${MY_PN}
	keepdir /var/lib/${MY_PN}

	fperms 0750 /var/lib/${MY_PN}

	newconfd "${FILESDIR}/${MY_PN}.confd" ${MY_PN}
	newinitd "${FILESDIR}/${MY_PN}.initd" ${MY_PN}

	insinto /etc/${MY_PN}
	newins ${MY_PN}.yml ${MY_PN}.yml.example

	dobin ${MY_PN}
}

pkg_postinst() {
	if [[ ! -e /etc/${MY_PN}/${MY_PN}.yml ]]; then
		elog "Before starting filebeat, you need to create a configuration file at:"
		elog "/etc/${MY_PN}/${MY_PN}.yml"
	fi
}
