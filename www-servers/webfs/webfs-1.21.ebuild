# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="Lightweight HTTP server for static content"
SRC_URI="http://dl.bytesex.org/releases/${PN}/${P}.tar.gz"
HOMEPAGE="http://linux.bytesex.org/misc/webfs.html"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ssl threads"

DEPEND="ssl? ( dev-libs/openssl:0= )"

RDEPEND="${DEPEND}
	app-misc/mime-types"

PATCHES=(
	"${FILESDIR}/${P}-Variables.mk-dont-strip-binaries-on-install.patch"
	"${FILESDIR}/${P}-CVE-2013-0347.patch"
)

src_prepare() {
	sed -e "s:/etc/mime.types:${EPREFIX}\\0:" -i GNUmakefile || die "sed failed"
	default
}

src_compile() {
	local myconf
	use ssl || myconf="${myconf} USE_SSL=no"
	use threads && myconf="${myconf} USE_THREADS=yes"

	emake prefix="${EPREFIX}/usr" ${myconf}
}

src_install() {
	local myconf
	use ssl || myconf="${myconf} USE_SSL=no"
	use threads && myconf="${myconf} USE_THREADS=yes"
	emake DESTDIR="${D}" install prefix="${EPREFIX}/usr"  ${myconf} mandir="${ED}/usr/share/man"
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit "${FILESDIR}/${PN}.service"
	systemd_install_serviced "${FILESDIR}/${PN}.service.conf"
	dodoc README
}

pkg_preinst() {
	# Fix existing log permissions for bug #458892.
	chmod 0600 "${EROOT}/var/log/webfsd.log" 2>/dev/null
}
