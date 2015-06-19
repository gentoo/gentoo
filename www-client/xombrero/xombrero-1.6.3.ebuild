# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/xombrero/xombrero-1.6.3.ebuild,v 1.2 2014/03/01 22:22:26 mgorny Exp $

EAPI="5"

if [[ ${PV} = *9999* ]]; then
	GIT_ECLASS=git-2
fi

inherit eutils fdo-mime toolchain-funcs ${GIT_ECLASS}

DESCRIPTION="A minimalist web browser with sophisticated security features designed-in"
HOMEPAGE="http://opensource.conformal.com/wiki/xombrero"

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="git://opensource.conformal.com/${PN}.git
		https://opensource.conformal.com/git/${PN}.git"
	EGIT_SOURCEDIR="${WORKDIR}/${P}"
	KEYWORDS=""
else
	SRC_URI="http://opensource.conformal.com/snapshots/${PN}/${P}.tgz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="ISC"
SLOT="0"
IUSE="examples"

RDEPEND="dev-libs/glib:2
	dev-libs/libbsd
	dev-libs/libgcrypt:0
	net-libs/libsoup
	net-libs/gnutls
	net-libs/webkit-gtk:3
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	x11-libs/pango"
DEPEND="${RDEPEND}
	dev-lang/perl
	sys-apps/groff
	dev-libs/atk
	dev-libs/libxml2
	media-libs/fontconfig
	media-libs/freetype
	media-libs/libpng:0
	x11-libs/cairo
	x11-libs/libdrm
	x11-libs/pixman"

S="${WORKDIR}/${P}/linux"

src_prepare() {
	sed -i \
		-e 's/-O2//' \
		-e 's/-ggdb3//' \
		-e 's,install: all,install: all\n\tinstall -m 755 -d $(DESTDIR)$(PREFIX)/share/applications,g' \
		Makefile || die 'sed Makefile failed.'
	sed -i \
		-e 's#https://www\.cyphertite\.com#http://www.gentoo.org/#' \
		-e "s#/usr/local#/usr#" \
		../xombrero.h || die 'sed ../xombrero.c failed.'
	sed -i \
		"s#Icon=#Icon=/usr/share/${PN}/#" \
		../xombrero.desktop || die 'sed ../xombrero.desktop failed.'
	sed -i "s:Application;::" ../xombrero.desktop || die
}

src_compile() {
	CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDADD="${LDFLAGS}" emake
}

src_install() {
	emake \
		DESTDIR="${D}" \
		PREFIX=/usr \
		install

	if use examples;then
		insinto "/usr/share/doc/${PF}/examples"
		doins \
			../${PN}.conf \
			../playflash.sh \
			../favorites
	fi
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
