# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rpm systemd

MY_P="Nessus-${PV}-es8"

DESCRIPTION="A remote security scanner for Linux"
HOMEPAGE="https://www.tenable.com/"
SRC_URI="${MY_P}.x86_64.rpm"

LICENSE="GPL-2 Nessus-EULA"
SLOT="0"
KEYWORDS="-* ~amd64"

RESTRICT="mirror fetch strip"

QA_PREBUILT="opt/nessus/bin/nasl
	opt/nessus/bin/ndbg
	opt/nessus/bin/nessus-mkrand
	opt/nessus/bin/openssl
	opt/nessus/lib/nessus/fips.so
	opt/nessus/lib/nessus/legacy.so
	opt/nessus/lib/nessus/libjemalloc.so.2
	opt/nessus/lib/nessus/libnessus-glibc-fix.so
	opt/nessus/lib/nessus/iconv/*.so
	opt/nessus/sbin/nessus-service
	opt/nessus/sbin/nessuscli
	opt/nessus/sbin/nessusd"

S="${WORKDIR}"

pkg_nofetch() {
	einfo "Please download ${A} from ${HOMEPAGE}downloads/nessus"
	einfo "The archive should then be placed into your DISTDIR directory."
}

src_install() {
	# Using doins -r would strip executable bits from all binaries
	cp -pPR "${S}"/opt "${D}"/ || die "Failed to copy files"

	# Make sure these originally empty directories do not vanish,
	# Nessus will not run properly without them
	keepdir /opt/nessus/com/nessus/CA
	keepdir /opt/nessus/etc/nessus
	keepdir /opt/nessus/var/nessus/logs
	keepdir /opt/nessus/var/nessus/tmp

	newinitd "${FILESDIR}"/nessusd-initd nessusd-bin
	systemd_newunit usr/lib/systemd/system/nessusd.service nessusd-bin.service
}

pkg_postinst() {
	# Actually update Nessus core components. According to upstream packages,
	# harmless to invoke on fresh installations too - and it may make life easier
	# for people who had restored Nessus state from backups, had it lying around
	# from older installations and so on.
	"${EROOT}"/opt/nessus/sbin/nessuscli install "${EROOT}"/opt/nessus/var/nessus/plugins-core.tar.gz

	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog "To get started launch the nessusd-bin service, then point your Web browser to"
		elog "  https://<yourhost>:8834/"
	else
		elog "Please restart the nessusd-bin service to use the new version of Nessus"
	fi
}
