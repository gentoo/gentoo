# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="library and programs to process reports from NetFlow data"
HOMEPAGE="https://github.com/5u623l20/flow-tools/"
SRC_URI="https://github.com/5u623l20/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc ~x86"
IUSE="debug libressl mysql postgres ssl static-libs"

RDEPEND="
	acct-group/flows
	acct-user/flows
	sys-apps/tcp-wrappers
	sys-libs/zlib
	mysql? ( dev-db/mysql-connector-c:0= )
	postgres? ( dev-db/postgresql:* )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	app-text/docbook-sgml-utils
	sys-devel/bison
	sys-devel/flex
"
DOCS=( ChangeLog.old README README.fork SECURITY TODO TODO.old )
PATCHES=(
	"${FILESDIR}"/${PN}-0.68.5.1-run.patch
	"${FILESDIR}"/${PN}-0.68.5.1-openssl11.patch
	"${FILESDIR}"/${PN}-0.68.5.1-fno-common.patch
	"${FILESDIR}"/${PN}-0.68.6-mysql.patch
)

src_prepare() {
	default
	sed -i -e 's|docbook-to-man|docbook2man|g' docs/Makefile.am || die
	eautoreconf
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

	find "${ED}" -name '*.la' -delete || die
}
