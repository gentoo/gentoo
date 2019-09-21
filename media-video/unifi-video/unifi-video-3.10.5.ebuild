# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit systemd user

MY_PV="${PV/_beta/-beta.}"
DESCRIPTION="UniFi Video Server"
HOMEPAGE="https://www.ubnt.com/download/unifi-video/"
SRC_URI="https://dl.ubnt.com/firmwares/ufv/v${MY_PV}/unifi-video.Ubuntu16.04_amd64.v${MY_PV}.deb"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="mirror"

DEPEND=""
RDEPEND="dev-db/mongodb
	dev-java/commons-daemon
	sys-apps/lsb-release
	sys-libs/libcap
	virtual/jre:1.8"

S=${WORKDIR}
QA_PREBUILT="usr/lib*/${PN}/lib/*.so usr/lib*/${PN}/bin/*"

pkg_setup() {
	enewuser ${PN}
	enewgroup ${PN}
}

src_unpack() {
	default
	unpack "${WORKDIR}"/data.tar.gz
}

src_prepare() {
	eapply "${FILESDIR}"/commons-daemon-move.patch
	sed -i usr/sbin/${PN} \
		-e '/require_root$/d' \
		-e '/update_limits$/d' \
		-e '/ulimit/d' \
		-e '/coredump_filter/d' || die
	default
}

src_install() {
	static_dir="/usr/$(get_libdir)/${PN}"
	#install static data
	insinto ${static_dir}
	doins -r usr/lib/${PN}/*
	fperms -R +x ${static_dir}/bin
	fowners -R ${PN}:${PN} ${static_dir}/conf/evostream/

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

	into /usr
	dosbin usr/sbin/${PN}
	dosym ../../../bin/mongod ${static_dir}/bin/mongod

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service
}
