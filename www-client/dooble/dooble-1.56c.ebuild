# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils qmake-utils fdo-mime
DESCRIPTION="A Secure and Open Source Web Browser"
HOMEPAGE="http://dooble.sourceforge.net/"

SRC_URI="mirror://sourceforge/${PN}/Version%20${PV}/Dooble.d.tar.gz ->
${P}.tar.gz"

# icon sets are GPL-3 LGPL-2.1 while the code is BSD
LICENSE="BSD GPL-3 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-db/sqlite:3
	dev-libs/libgcrypt:0
	dev-libs/libgpg-error
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsql:5
	dev-qt/qtwebkit:5
	dev-qt/qtxml:5
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
"

S="${WORKDIR}/dooble.d/Version 1.x/"

src_prepare() {
	# Adjust paths from FreeBSD locations to Gentoo locations
	# XXX: Fix the build system to be more flexible and upstream fix
	sed -i -e 's/\(dooble.path[[:space:]]*= \)\(.*\)$/\1\/usr\/bin/' \
		-e 's/\(dooble_sh.path[[:space:]]*= \)\(.*\)$/\1\/usr\/share\/dooble/' \
		-e 's/\(icons.path[[:space:]]*= \)\(.*\)$/\1\/usr\/share\/dooble/' \
		-e 's/\(images.path[[:space:]]*= \)\(.*\)$/\1\/usr\/share\/dooble/' \
		-e 's/\(spoton_install.path[[:space:]]*= \)\(.*\)$/\1\/usr\/lib/' \
		-e 's/\(pluginsdir.path[[:space:]]*= \)\(.*\)$/\1\/usr\/lib\/nsbrowser\/plugins/' \
		-e 's/\(plugspec.path[[:space:]]*= \)\(.*\)$/\1\/usr\/include\/dooble\/plugin-spec/' \
		-e 's/\(postinstall.path[[:space:]]*= \)\(.*\)$/\1\/usr\/share\/dooble/' \
		-e 's/\(tab.path[[:space:]]*= \)\(.*\)$/\1\/usr\/share\/dooble/' \
		dooble.pro dooble.qt5.pro

	sed -i -e "s:\"Icons:\"${EROOT}usr/share/dooble/Icons:" \
		./Source/dsettings.cc
	sed -i -e '/export/d' -e "s:/usr/local/dooble/Dooble:${EROOT}usr/bin/Dooble:g" \
		-e "s:cd /usr/local/dooble:cd /usr/share/dooble:" \
		-e "s:exec ./Dooble:exec ${EROOT}usr/bin/Dooble:" ./dooble.sh
	sed -i -e "s:/usr/local:${EROOT}/usr/share:" -e 's:/text/xml:text/xml:' \
		./dooble.desktop
}

src_configure() {
	eqmake5 dooble.qt5.pro
}

src_install() {
	dohtml Documentation/RELEASE-NOTES.html
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
