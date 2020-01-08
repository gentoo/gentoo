# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit user

DESCRIPTION="library and programs to process reports from NetFlow data"
HOMEPAGE="https://code.google.com/p/flow-tools/"
SRC_URI="https://${PN}.googlecode.com/files/${P}.tar.bz2"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="debug libressl mysql postgres ssl static-libs"

RDEPEND="sys-apps/tcp-wrappers
	sys-libs/zlib
	mysql? ( dev-db/mysql-connector-c:0= )
	postgres? ( dev-db/postgresql:* )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)"

DEPEND="${RDEPEND}
	sys-devel/flex
	sys-devel/bison"

DOCS=( ChangeLog README SECURITY TODO )

PATCHES=(
	"${FILESDIR}"/${P}-run.patch
	"${FILESDIR}"/${P}-syslog.patch
	"${FILESDIR}"/${P}-openssl11.patch
)

pkg_setup() {
	pkg_douser
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(usex mysql --with-mysql '') \
		$(usex postgres --with-postgresql=yes --with-postgresql=no) \
		$(usex ssl --with-openssl '') \
		--sysconfdir=/etc/flow-tools
}

src_install() {
	default

	find "${D}" -name '*.la' -delete || die

	exeinto /var/lib/flows/bin
	doexe "${FILESDIR}"/linkme

	keepdir /var/lib/flows/ft

	newinitd "${FILESDIR}/flowcapture.initd" flowcapture
	newconfd "${FILESDIR}/flowcapture.confd" flowcapture

	fowners flows:flows /var/lib/flows
	fowners flows:flows /var/lib/flows/bin
	fowners flows:flows /var/lib/flows/ft

	fperms 0755 /var/lib/flows
	fperms 0755 /var/lib/flows/bin
}

pkg_preinst() {
	pkg_douser
}

pkg_douser() {
	enewgroup flows
	enewuser flows -1 -1 /var/lib/flows flows
}
