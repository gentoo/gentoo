# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-nds/gosa-core/gosa-core-2.6.11.ebuild,v 1.2 2014/08/10 20:53:00 slyfox Exp $

EAPI=3

inherit eutils

DESCRIPTION="LDAP administration frontend for user administration"
HOMEPAGE="https://oss.gonicus.de/labs/gosa/wiki/WikiStart."
SRC_URI="ftp://oss.gonicus.de/pub/gosa/${P}.tar.bz2
	http://oss.gonicus.de/pub/gosa/${P}.tar.bz2
	ftp://oss.gonicus.de/pub/gosa/archive/${P}.tar.bz2
	http://oss.gonicus.de/pub/gosa/archive/${P}.tar.bz2	"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="mail samba"

DEPEND="dev-lang/php[iconv,imap,ldap,mysql,session,zip]
	sys-devel/gettext"
RDEPEND="${DEPEND}
	virtual/httpd-php
	dev-perl/Crypt-SmbHash
	media-gfx/imagemagick"
PDEPEND="mail? ( ~net-nds/gosa-plugin-mail-${PV} )
	samba? ( ~net-nds/gosa-plugin-samba-${PV} )"

src_prepare() {
	epatch \
		"${S}/redhat/02_fix_class_mapping.patch" \
		"${S}/redhat/03_fix_locale_location.patch" \
		"${S}/redhat/04_fix_online_help_location.patch"
	sed -i \
		-e 's|../contrib|/usr/share/gosa/template|' \
		include/functions.inc || die "sed failed"
}

src_install() {
	insinto /usr/share/gosa
	doins -r doc html ihtml include locale plugins setup

	insinto /usr/share/gosa/template
	doins contrib/gosa.conf

	dosbin \
		update-gosa \
		bin/gosa-encrypt-passwords

	dobin \
		update-locale \
		update-online-help \
		update-pdf-help \
		dh-make-gosa \
		contrib/gosa

	insinto /etc/gosa
	doins \
		contrib/shells \
		contrib/encodings \
		contrib/desktoprc
	touch "${D}/etc/gosa/gosa.secrets"

	doicon debian/*.xpm
	domenu debian/gosa-desktop.desktop

	doman *.1 contrib/*.1 contrib/*.5

	dodoc contrib/openldap/slapd.conf
	insinto /etc/openldap/schema/gosa
	doins contrib/openldap/*.schema

	insinto /etc/apache2/vhosts.d
	doins "${FILESDIR}/gosa.include"

	dodoc AUTHORS Changelog FAQ README README.safemode

	keepdir /etc/gosa
	keepdir /var/spool/gosa
	keepdir /var/cache/gosa
}

pkg_prerm() {
	ebegin "Flushing the class and locale cache"
	rm -r "${EROOT}"var/cache/gosa/*
	eend $?
	ebegin "Clearing the spool directory"
	rm -r "${EROOT}"var/spool/gosa/*
	eend $?
}

pkg_postinst() {
	ebegin "Generating class cache and locales"
	"${EROOT}"usr/sbin/update-gosa
	eend $?

	elog "Please make sure that the web server you are going to use has"
	elog "read-write access to ${EROOT}var/spool/gosa"

	elog "For Apache there is the gosa.include file in ${EROOT}etc/apache/vhosts.d."
	elog "You can either use it as a template for your configuration or directly"
	elog "include it in your apache configuration."

	elog "GOsa requires some objectclasses and attributes to be present in the"
	elog "directory. A sample configuration for slapd.conf can be found here:"
	elog "    ${EROOR}usr/share/doc/${PF}/slapd.conf[.gz]"
}
