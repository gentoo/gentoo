# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Used, when it's an unstable, beta or release candidate
RC_SUFFIX="-6e1800b9b9"

inherit systemd user

DESCRIPTION="A Management Controller for Ubiquiti Networks UniFi APs"
HOMEPAGE="https://www.ubnt.com"
SRC_URI="https://dl.ubnt.com/unifi/${PV}${RC_SUFFIX}/UniFi.unix.zip -> ${P}.zip"

KEYWORDS="~amd64"
LICENSE="Apache-1.0 Apache-2.0 BSD-1 BSD-2 BSD CDDL EPL-1.0 GPL-2 LGPL-2.1 LGPL-3 MIT ubiquiti"
SLOT="0/5.10"
IUSE="systemd"

RDEPEND="dev-db/mongodb
	virtual/jre:1.8"

DEPEND="app-arch/unzip"

RESTRICT="bindist mirror"

S="${WORKDIR}/UniFi"

DOCS=( "readme.txt" )

QA_PREBUILT="usr/lib/unifi/lib/native/Linux/x86_64/*.so"

pkg_setup() {
	enewgroup unifi
	enewuser unifi -1 -1 /var/lib/unifi unifi
}

src_prepare() {
	# Remove unneeded files Linux, Mac and Windows
	rm -r lib/native/Linux/{aarch64,armv7} lib/native/{Mac,Windows} || die
	if ! use systemd; then
		rm lib/native/Linux/x86_64/libubnt_sdnotify_jni.so || die
	fi

	default
}

src_install() {
	# Install MongoDB wrapper script, to avoid problems with >= 3.6.0
	# See https://community.ubnt.com/t5/UniFi-Routing-Switching/MongoDB-3-6/td-p/2195435
	exeinto /usr/lib/unifi/bin
	newexe "${FILESDIR}"/mongod-wrapper mongod

	insinto /usr/lib/unifi
	doins -r dl lib webapps

	diropts -o unifi -g unifi
	keepdir /var/lib/unifi/{conf,data,run,tmp,work} /var/log/unifi

	for symlink in conf data run tmp work; do
		dosym ../../../var/lib/unifi/${symlink} /usr/lib/unifi/${symlink}
	done
	dosym ../../../var/log/unifi /usr/lib/unifi/logs

	newinitd "${FILESDIR}"/unifi.initd-r1 unifi
	systemd_dounit "${FILESDIR}"/unifi.service

	newconfd "${FILESDIR}"/unifi.confd unifi

	echo 'CONFIG_PROTECT="/var/lib/unifi"' > "${T}"/99unifi || die
	doenvd "${T}"/99unifi

	einstalldocs
}
