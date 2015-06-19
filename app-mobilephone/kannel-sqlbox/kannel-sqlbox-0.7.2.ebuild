# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-mobilephone/kannel-sqlbox/kannel-sqlbox-0.7.2.ebuild,v 1.4 2013/07/25 01:53:56 creffett Exp $

EAPI="2"

inherit eutils autotools

DESCRIPTION="DB-Based Kannel Box for message queueing"
HOMEPAGE="http://www.kannel.org/~aguerrieri/SqlBox/"
SRC_URI="http://www.kannel.org/~aguerrieri/SqlBox/Releases/sqlbox-${PV}.tar.gz"

LICENSE="Apache-1.1 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ssl doc"

RDEPEND="|| (
		>=app-mobilephone/kannel-1.4.3-r1[mysql]
		>=app-mobilephone/kannel-1.4.3-r1[sqlite]
		>=app-mobilephone/kannel-1.4.3-r1[postgres]
	)
	ssl? ( dev-libs/openssl )"
DEPEND="${RDEPEND}
	doc? ( media-gfx/transfig
		app-text/jadetex
		app-text/docbook-dsssl-stylesheets
		app-text/docbook-sgml-dtd:3.1 )"

S="${WORKDIR}/sqlbox-${PV}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-sqlinit-hfiles.patch
	epatch "${FILESDIR}"/${P}-configure.patch

	# This package doesn't contain configure script, only configure.in
	eautoreconf
}

src_configure() {
	econf --docdir=/usr/share/doc/${PF} \
		--without-ctlib \
		--without-mssql \
		$(use_enable ssl) \
		$(use_enable doc docs) \
		|| die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "failed emake install"

	if use doc; then
		emake doc/userguide.html || die "emake docs failed"
		dohtml doc/userguide.html || die "userguide.html not found"
	fi

	newinitd "${FILESDIR}"/kannel-sqlbox.initd kannel-sqlbox

	dodoc AUTHORS ChangeLog NEWS README
	insinto /etc/kannel
	newins example/sqlbox.conf.example sqlbox.conf.sample
}

pkg_postinst() {
	elog "Please view the following page for config information:"
	elog "http://www.kannel.org/pipermail/users/2006-October/000859.html"
	elog ""
	elog "In essence you need to do 3 things"
	elog "1. Create the database (tables will be automatically created by kannel)"
	elog "2. Point sqlbox to the smsbox-port in kannel [core] group"
	elog "3. Point smsbox to smsbox-port in sqlbox [sqlbox] group"
	elog ""
	elog "This literally puts sqlbox in between the bearerbox and smsbox"
	elog "for data storage into a database"
}
