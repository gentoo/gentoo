# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit libtool autotools eutils

DESCRIPTION="HTTP Antivirus for Squid based on ClamAV and ICAP"
HOMEPAGE="http://squidclamav.darold.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="net-proxy/c-icap
	app-arch/libarchive"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-Makefile.in.patch"
	"${FILESDIR}/${P}-${PN}.conf.patch"
	"${FILESDIR}/${P}-${PN}.h.patch"
	"${FILESDIR}/${P}-${PN}.c.patch"
	"${FILESDIR}/${P}-clwarn.cgi.patch"
)

src_configure() {
	econf --disable-static --enable-shared
}

src_install() {
	emake DESTDIR="${D}" install
	find "${D}" -name '*.la' -delete || die

	# delete its own documentation installed
	rm -r "${D}"/usr/share/${PN} || die

	dodoc README AUTHORS ChangeLog

	# Fix configuration file to adapt to the Gentoo configuration
	sed -i \
		-e '/clamd_local/s:\.ctl:.sock:' \
		"${D}"/etc/c-icap/squidclamav.conf || die
}

pkg_postinst() {
	elog "Starting from version 6, Squid Clamav is now a module for the c-icap"
	elog "server, which is called from squid, rather than being a redirector"
	elog "directly."
	elog ""
	elog "To enable the service, you should add this to your c-icap.conf file:"
	elog ""
	elog "    Service clamav squidclamav.so"
	elog ""
	elog "And then this to squid.conf (for a local ICAP server):"
	elog ""
	elog "    icap_enable on"
	elog ""
	elog "    # not strictly needed, but useful for special access"
	elog "    icap_send_client_ip on"
	elog "    icap_send_client_username on"
	elog ""
	elog "    icap_service clamav respmod_precache bypass=0 icap://localhost:1344/clamav"
	elog "    adaptation_access clamav allow all"
}
