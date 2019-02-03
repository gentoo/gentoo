# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils java-pkg-2 java-ant-2 systemd

MY_P=${PN}_src_${PV//./_}
DESCRIPTION="Openfire (formerly wildfire) real time collaboration (RTC) server"
HOMEPAGE="http://www.igniterealtime.org/projects/openfire/"
SRC_URI="http://www.igniterealtime.org/builds/openfire/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=">=virtual/jre-1.7"
DEPEND="net-im/jabber-base
	~dev-java/ant-contrib-1.0_beta2
	>=virtual/jdk-1.7"

S=${WORKDIR}/${PN}_src

pkg_setup() {
	if [[ -f /etc/env.d/98openfire ]]; then
		einfo "This is an upgrade"
		ewarn "As the plugin API changed, at least these plugins need to be updated also:"
		ewarn "User Search, IM Gateway, Fastpath, Monitoring"
		ewarn "they can be downloaded via Admin Console or at"
		ewarn "    ${HOMEPAGE}"
	else
		ewarn "If this is an upgrade stop right ( CONTROL-C ) and run the command:"
		ewarn "echo 'CONFIG_PROTECT=\"/opt/openfire/resources/security/\"' > /etc/env.d/98openfire "
		ewarn "For more info see bug #139708"
		sleep 11
	fi
	java-pkg-2_pkg_setup
}

src_compile() {
	# Jikes doesn't support -source 1.5
	java-pkg_filter-compiler jikes

	ANT_TASKS="ant-contrib"
	eant -f build/build.xml openfire plugins $(use_doc)

	# delete nativeAuth prebuilt libs:
	#    uses outdated unmaintained libshaj, does not support amd64
	rm -rfv target/openfire/resources/nativeAuth || die
}

src_install() {
	dodir /opt/openfire

	newinitd "${FILESDIR}"/openfire-initd openfire
	newconfd "${FILESDIR}"/openfire-confd openfire
	systemd_dounit "${FILESDIR}"/${PN}.service

	dodir /opt/openfire/conf
	insinto /opt/openfire/conf
	newins target/openfire/conf/openfire.xml openfire.xml.sample
	newins target/openfire/conf/security.xml security.xml.sample

	dodir /opt/openfire/logs
	keepdir /opt/openfire/logs

	dodir /opt/openfire/lib
	insinto /opt/openfire/lib
	doins target/openfire/lib/*

	dodir /opt/openfire/plugins
	insinto /opt/openfire/plugins
	doins -r target/openfire/plugins/*

	dodir /opt/openfire/resources
	insinto /opt/openfire/resources
	doins -r target/openfire/resources/*

	if use doc; then
		dohtml -r documentation/docs/*
	fi
	dodoc documentation/dist/*

	#Protect ssl key on upgrade
	dodir /etc/env.d/
	echo 'CONFIG_PROTECT="/opt/openfire/resources/security/"' > "${D}"/etc/env.d/98openfire
}

pkg_postinst() {
	local src
	local dst

	# http://community.igniterealtime.org/thread/52289
	for dst in "${ROOT}"/opt/openfire/conf/{openfire,security}.xml
	do
		src="${dst}".sample
		if [[ -f "${dst}" ]]; then
			einfo "Leaving old '${dst}'"
		else
			einfo "Created default '${dst}'. Please edit."
			cp -v "${src}" "${dst}" || ewarn "cp '${dst}' failed"
			chmod -v 0600 "${dst}" || ewarn "chmod '${dst}' failed"
		fi
	done
	chown -R jabber:jabber "${ROOT}"/opt/openfire
}
