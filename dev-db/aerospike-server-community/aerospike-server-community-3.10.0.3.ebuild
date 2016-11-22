# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils user

DESCRIPTION="Flash-optimized, in-memory, nosql database"
HOMEPAGE="http://www.aerospike.com"
SRC_URI="http://www.aerospike.com/artifacts/${PN}/${PV}/${P}-debian7.tgz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="app-crypt/gcr"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P}-debian7"

pkg_setup() {
	enewgroup aerospike
	enewuser aerospike -1 /bin/bash /opt/aerospike aerospike
}

src_prepare() {
	local server_deb="${P}.debian7.x86_64.deb"
	local tools_deb="aerospike-tools-3.10.2.debian7.x86_64.deb"

	ar x "${server_deb}" || die
	tar xzf data.tar.gz && rm data.tar.gz || die

	ar x "${tools_deb}" || die
	tar xzf data.tar.gz && rm data.tar.gz || die

	rm *.deb asinstall control.tar.gz debian-binary LICENSE SHA256SUMS
	rm usr/bin/{asfixownership,asmigrate2to3}
}

src_install() {
	insinto /opt/
	doins -r opt/aerospike

	fperms +x -R /opt/aerospike/bin/
	fperms +x -R /opt/aerospike/lib/python/

	for dir in '/etc' '/var/log'; do
		keepdir "${dir}/aerospike"
	done

	insinto /etc/aerospike
	for conf in 'aerospike.conf' 'aerospike_mesh.conf' 'aerospike_ssd.conf'; do
		doins "${FILESDIR}/${conf}"
	done

	insinto /usr/bin
	doins usr/bin/*
	fperms +x -R /usr/bin/asd

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/aerospike.logrotate aerospike

	newinitd "${FILESDIR}"/aerospike.init aerospike

	fowners -R aerospike:aerospike /opt/aerospike/
	fowners aerospike:aerospike /usr/bin/asd
	fowners -R aerospike:aerospike /var/log/aerospike
}
