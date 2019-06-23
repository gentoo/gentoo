# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

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
	#Protect ssl key on upgrade
	dodir /etc/env.d/
	echo 'CONFIG_PROTECT="/opt/openfire/conf/ /opt/openfire/resources/security/"' > "${D}"/etc/env.d/98openfire

	newinitd "${FILESDIR}"/openfire-initd openfire
	newconfd "${FILESDIR}"/openfire-confd openfire
	systemd_dounit "${FILESDIR}"/${PN}.service

	diropts --owner=jabber --group=jabber
	insopts --owner=jabber --group=jabber
	dodir /opt/openfire

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

	dodir /opt/openfire/conf
	insinto /opt/openfire/conf
	insopts --mode=0600 --owner=jabber --group=jabber
	newins target/openfire/conf/openfire.xml openfire.xml
	newins target/openfire/conf/security.xml security.xml
}
