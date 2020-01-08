# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils flag-o-matic readme.gentoo-r1

DESCRIPTION="DB-Based Kannel Box for message queueing"
HOMEPAGE="http://www.kannel.org/"
SRC_URI="http://www.kannel.org/download/${PV}/gateway-${PV}.tar.gz"

LICENSE="Apache-1.1 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ssl doc"

RDEPEND="|| (
		~app-mobilephone/kannel-${PV}[mysql]
		~app-mobilephone/kannel-${PV}[sqlite]
		~app-mobilephone/kannel-${PV}[postgres]
	)
	net-libs/libnsl:0=
	ssl? ( dev-libs/openssl:0 )"
DEPEND="${RDEPEND}
	doc? ( media-gfx/transfig
		app-text/jadetex
		app-text/docbook-dsssl-stylesheets
		app-text/docbook-sgml-dtd:3.1 )"

S="${WORKDIR}/gateway-${PV}/addons/sqlbox/"

pkg_setup() {
	append-ldflags $(no-as-needed)
	DISABLE_AUTOFORMATTING="yes"
	DOC_CONTENTS="Please view the following page for config information:
http://www.kannel.org/pipermail/users/2006-October/000859.html

In essence you need to do 3 things:
1. Create the database (tables will be automatically created by kannel)
2. Point sqlbox to the smsbox-port in kannel [core] group
3. Point smsbox to smsbox-port in sqlbox [sqlbox] group

This literally puts sqlbox in between the bearerbox and smsbox
for data storage into a database"
}

src_configure() {
	econf --docdir=/usr/share/doc/${PF} \
		--without-ctlib \
		--without-mssql \
		$(use_enable ssl) \
		$(use_enable doc docs)
}

src_install() {
	emake DESTDIR="${D}" install

	if use doc; then
		emake doc/userguide.html
		dohtml doc/userguide.html
	fi

	newinitd "${FILESDIR}"/kannel-sqlbox.initd kannel-sqlbox

	dodoc AUTHORS ChangeLog NEWS README
	insinto /etc/kannel
	newins example/sqlbox.conf.example sqlbox.conf.sample

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
