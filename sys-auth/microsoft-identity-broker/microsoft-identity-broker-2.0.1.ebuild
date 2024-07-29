# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2 prefix systemd unpacker

FAKE_OS="ubuntu-22.04"
DESCRIPTION="Microsoft Authentication Broker to access a corporate environment"
HOMEPAGE="https://learn.microsoft.com/mem/intune/"
SRC_URI="https://packages.microsoft.com/ubuntu/22.04/prod/pool/main/${PN:0:1}/${PN}/${PN}_${PV}_amd64.deb"
S="${WORKDIR}"
LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="bindist mirror"

RDEPEND="
	acct-user/microsoft-identity-broker
	acct-group/microsoft-identity-broker
	sys-apps/bubblewrap
	sys-apps/dbus
	virtual/jre:11
"

src_unpack() {
	unpack_deb ${A}
}

src_configure() {
	sed -i -r "s:^Exec(Start)?=.*/([^/]+):Exec\1=${EPREFIX}/usr/bin/\2:" \
		usr/lib/systemd/*/*.service usr/share/dbus-1/*/*.service || die
}

src_install() {
	newbin $(prefixify_ro "${FILESDIR}"/wrapper) microsoft-identity-broker
	dosym microsoft-identity-broker /usr/bin/microsoft-identity-device-broker

	java-pkg_dojar opt/microsoft/identity-broker/lib/*.jar

	java-pkg_dolauncher microsoft-identity-broker \
		--main com.microsoft.identity.broker.service.IdentityBrokerService \
		--java_args '${MICROSOFT_IDENTITY_BROKER_OPTS}' \
		-into /usr/share/${PN}

	java-pkg_dolauncher microsoft-identity-device-broker \
		--main com.microsoft.identity.broker.service.DeviceBrokerService \
		--java_args '${MICROSOFT_IDENTITY_DEVICE_BROKER_OPTS}' \
		-into /usr/share/${PN}

	insinto /etc/microsoft-identity-broker
	newins "${FILESDIR}/lsb-release-${FAKE_OS}" lsb-release
	newins "${FILESDIR}/os-release-${FAKE_OS}" os-release

	insinto /usr/share
	doins -r usr/share/dbus-1

	systemd_dounit usr/lib/systemd/system/*
	systemd_douserunit usr/lib/systemd/user/*
}
