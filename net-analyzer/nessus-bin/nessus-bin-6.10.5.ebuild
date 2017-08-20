# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit rpm pax-utils systemd

MY_P="Nessus-${PV}-es7"

DESCRIPTION="A remote security scanner for Linux"
HOMEPAGE="https://www.tenable.com/"
SRC_URI="${MY_P}.x86_64.rpm"

LICENSE="GPL-2 Nessus-EULA"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="mirror fetch strip"

QA_PREBUILT="opt/nessus/bin/nasl
	opt/nessus/bin/ndbg
	opt/nessus/bin/nessus-mkrand
	opt/nessus/lib/nessus/libjemalloc.so.${PV}
	opt/nessus/lib/nessus/libnessus-glibc-fix.so
	opt/nessus/sbin/nessus-check-signature
	opt/nessus/sbin/nessus-service
	opt/nessus/sbin/nessuscli
	opt/nessus/sbin/nessusd"

S="${WORKDIR}"

pkg_nofetch() {
	einfo "Please download ${A} from ${HOMEPAGE}/download"
	einfo "The archive should then be placed into ${DISTDIR}."
}

src_install() {
	# Using doins -r would strip executable bits from all binaries
	cp -pPR "${S}"/opt "${D}"/ || die "Failed to copy files"

	pax-mark m "${D}"/opt/nessus/sbin/nessusd

	# Make sure these originally empty directories do not vanish,
	# Nessus will not run properly without them
	keepdir /opt/nessus/com/nessus/CA
	keepdir /opt/nessus/etc/nessus
	keepdir /opt/nessus/lib/nessus/plugins
	keepdir /opt/nessus/var/nessus/logs
	keepdir /opt/nessus/var/nessus/tmp
	keepdir /opt/nessus/var/nessus/users

	newinitd "${FILESDIR}"/nessusd-initd nessusd-bin
	systemd_newunit usr/lib/systemd/system/nessusd.service nessusd-bin.service
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog "To get started launch the nessusd-bin service, then point your Web browser to"
		elog "  https://<yourhost>:8834/"
	else
		elog "You may want to restart the nessusd-bin service to use"
		elog "the new version of Nessus."
	fi
}
