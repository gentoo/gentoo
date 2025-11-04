# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools eapi9-ver

DESCRIPTION="library and programs to process reports from NetFlow data"
HOMEPAGE="https://github.com/5u623l20/flow-tools/"
SRC_URI="https://github.com/5u623l20/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="debug mysql postgres ssl static-libs"

RDEPEND="
	acct-group/flows
	acct-user/flows
	sys-apps/tcp-wrappers
	virtual/zlib
	mysql? ( dev-db/mysql-connector-c:= )
	postgres? ( dev-db/postgresql:* )
	ssl? ( dev-libs/openssl:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/docbook-sgml-utils
	app-alternatives/lex
	sys-devel/bison
"

DOCS=( ChangeLog.old README README.fork SECURITY TODO TODO.old )

PATCHES=(
	"${FILESDIR}"/${PN}-0.68.5.1-run.patch
	"${FILESDIR}"/${PN}-0.68.5.1-openssl11.patch
	"${FILESDIR}"/${PN}-0.68.5.1-fno-common.patch
	"${FILESDIR}"/${PN}-0.68.6-mysql.patch
	"${FILESDIR}"/${PN}-0.68.6-c99-c23.patch
	"${FILESDIR}"/${PN}-0.68.6-lto.patch
)

src_prepare() {
	default

	sed -i -e 's|docbook-to-man|docbook2man|g' docs/Makefile.am || die
	eautoreconf
}

src_configure() {
	# Needs bison specifically for LTO patch (for setting a prefix)
	unset YACC

	local myeconfargs=(
		$(use_enable static-libs static)

		# configure logic is buggy
		$(usev mysql --with-mysql)
		--with-postgresql=$(usex postgres yes no)
		$(usev ssl --with-openssl)
	)

	econf "${myeconfargs[@]}"
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

pkg_postinst() {
	if ver_replacing -lt 0.68.6-r2 ; then
		ewarn "Config files have been moved bak to ${EPREFIX}/etc/flow-tools"
		ewarn "after temporarily being in the wrong location of"
		ewarn " ${EPREFIX}/etc/flow-tools/flow-tools"
		ewarn "See bug #785040."
	fi
}
