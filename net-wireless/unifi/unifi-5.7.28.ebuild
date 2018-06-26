# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit systemd user

# for not-stable releases set RC_SUFFIX="-xxxxxxxxxx"
RC_SUFFIX="-5c442c6b54"

DESCRIPTION="Management Controller for UniFi APs"
HOMEPAGE="https://www.ubnt.com/download/unifi"
SRC_URI="http://dl.ubnt.com/unifi/${PV}${RC_SUFFIX}/UniFi.unix.zip -> ${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="mirror"

DEPEND=""
RDEPEND="dev-db/mongodb
	virtual/jre"

S=${WORKDIR}/UniFi
QA_PREBUILT="/usr/lib64/unifi/lib/native/*"

pkg_setup() {
	enewuser ${PN}
	enewgroup ${PN}
}

src_install(){
	static_dir="/usr/$(get_libdir)/${PN}"
	#install static data
	insinto ${static_dir}
	doins -r *
	#prepare runtime-data dirs which live in /var but are symlinked from static
	#data dir, and are writable by non-root user
	dodir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}
	dosym ../../../var/log/${PN} ${static_dir}/logs

	dodir /var/lib/${PN}/work
	fowners ${PN}:${PN} /var/lib/${PN}/work
	dosym ../../../var/lib/${PN}/work ${static_dir}/work

	keepdir /var/lib/${PN}/data
	fowners ${PN}:${PN} /var/lib/${PN}/data
	dosym ../../../var/lib/${PN}/data ${static_dir}/data

	echo "CONFIG_PROTECT=\"/var/lib/${PN}/data/system.properties\"" > "${T}"/99${PN}
	doenvd "${T}"/99${PN}

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service
}
