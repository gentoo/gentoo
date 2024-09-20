# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Set this var for any releases except stable
# RC_SUFFIX="-"

inherit java-pkg-2 readme.gentoo-r1 systemd

DESCRIPTION="A Management Controller for Ubiquiti Networks UniFi APs"
HOMEPAGE="https://www.ubnt.com"
SRC_URI="https://dl.ui.com/unifi/${PV}${RC_SUFFIX}/UniFi.unix.zip -> ${P}.zip"
S="${WORKDIR}/UniFi"

LICENSE="Apache-1.0 Apache-2.0 BSD-1 BSD-2 BSD CDDL EPL-1.0 GPL-2 LGPL-2.1 LGPL-3 MIT ubiquiti"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="-* amd64 ~arm64"
IUSE="systemd system-mongodb"
RESTRICT="bindist mirror"

RDEPEND="
	acct-group/unifi
	acct-user/unifi
	dev-db/mongodb
	virtual/jre:17
"

BDEPEND="app-arch/unzip"

DOCS=( "readme.txt" )

QA_PREBUILT="
	usr/lib/unifi/lib/native/Linux/aarch64/*.so
	usr/lib/unifi/lib/native/Linux/x86_64/*.so
"

src_prepare() {
	if [[ ${CHOST} != aarch64* ]]; then
		rm -r lib/native/Linux/aarch64 || die
	fi
	if [[ ${CHOST} != x86_64* ]]; then
		rm -r lib/native/Linux/x86_64 || die
	fi

	if [[ ${CHOST} == aarch64* ]]; then
		if ! use systemd; then
			rm lib/native/Linux/aarch64/libubnt_sdnotify_jni.so || die
		fi
	fi
	if [[ ${CHOST} == x86_64* ]]; then
		if ! use systemd; then
			rm lib/native/Linux/x86_64/libubnt_sdnotify_jni.so || die
		fi
	fi

	default
}

src_compile() {
	:;
}

src_install() {
	insinto /usr/lib/unifi
	doins -r dl lib webapps
	! use system-mongodb && doins -r bin

	diropts -o unifi -g unifi
	keepdir /var/lib/unifi/{conf,data,run,tmp,work} /var/log/unifi

	for symlink in conf data run tmp work; do
		dosym ../../../var/lib/unifi/${symlink} /usr/lib/unifi/${symlink}
	done
	dosym ../../../var/log/unifi /usr/lib/unifi/logs

	java-pkg_regjar "${D}"/usr/lib/unifi/lib/*.jar
	java-pkg_dolauncher \
		unifi \
		--java_args '-Dorg.xerial.snappy.tempdir=/usr/lib/unifi/tmp \
			-Djava.library.path= \
			--add-opens java.base/java.lang=ALL-UNNAMED \
			--add-opens java.base/java.time=ALL-UNNAMED \
			--add-opens java.base/sun.security.util=ALL-UNNAMED \
			--add-opens java.base/java.io=ALL-UNNAMED \
			--add-opens java.rmi/sun.rmi.transport=ALL-UNNAMED' \
		--jar ace.jar \
		--pwd '/usr/lib/unifi'

	if use system-mongodb; then
		systemd_newunit "${FILESDIR}"/unifi-mongodb.service unifi.service
		newinitd "${FILESDIR}"/unifi-mongodb.initd unifi
	else
		systemd_newunit "${FILESDIR}"/unifi.service-r2 unifi.service
		newinitd "${FILESDIR}"/unifi.initd-r2 unifi
	fi

	newconfd "${FILESDIR}"/unifi.confd unifi

	echo 'CONFIG_PROTECT="/var/lib/unifi"' > "${T}"/99unifi || die
	doenvd "${T}"/99unifi

	einstalldocs
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
