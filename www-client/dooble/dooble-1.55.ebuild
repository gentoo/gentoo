# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils qt4-r2 fdo-mime
DESCRIPTION="A Secure and Open Source Web Browser"
HOMEPAGE="http://dooble.sourceforge.net/"

SRC_URI="mirror://sourceforge/${PN}/Version%20${PV}/Dooble_Src.d.tar.gz ->
${P}.tar.gz"

# icon sets are GPL-3 LGPL-2.1 while the code is BSD
LICENSE="BSD GPL-3 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
DEPEND="dev-db/sqlite:3
	dev-libs/libgcrypt:0/20
	dev-libs/libgpg-error
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtsql:4
	dev-qt/qtwebkit:4
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/dooble.d/Version 1.x/"

src_prepare() {
	# Adjust paths from FreeBSD locations to Gentoo locations
	# XXX: Fix the build system to be more flexible and upstream fix
	epatch "${FILESDIR}/00-dooble-${PV}-path-fix.patch"
	sed -i -e "s:\"Icons:\"${EROOT}usr/share/dooble/Icons:" \
		./Source/dsettings.cc
	sed -i -e '/export/d' -e "s:/usr/local/dooble/Dooble:${EROOT}usr/bin/Dooble:g" \
		-e "s:cd /usr/local/dooble:cd /usr/share/dooble:" \
		-e "s:exec ./Dooble:exec ${EROOT}usr/bin/Dooble:" ./dooble.sh
	sed -i -e "s:/usr/local:${EROOT}/usr/share:" -e 's:/text/xml:text/xml:' \
		./dooble.desktop
}

src_configure() {
	eqmake4 dooble.pro
}

src_install() {
	dohtml ../Documentation/RELEASE-NOTES.html
	dodoc Documentation/{THEMES,TO-DO}
	dosym ../share/dooble/dooble.sh /usr/bin/dooble
	dosym ../../lib/nsbrowser/plugins /usr/share/dooble/Plugins
	dolib.so libSpotOn/libspoton.so
	emake INSTALL_ROOT="${ED}" install

	# XXX: The build system installs the build path into INSTALL_ROOT.
	# It should be fixed not to do this.
	rm -r "${ED}/var" || die "Failed to remove build path from ${ED}"
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
