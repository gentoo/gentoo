# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit qmake-utils xdg-utils

DESCRIPTION="A small, lightweight file manager for desktops based on pure Qt"
HOMEPAGE="http://www.qtfm.org/"
SRC_URI="https://dev.gentoo.org/~jer/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	sys-apps/file
"
DEPEND="
	${RDEPEND}
	dev-qt/qtchooser
"
PATCHES=( "${FILESDIR}"/${PN}-5.5-gcc6.patch )
S=${WORKDIR}/${PN}-master

QTFM_LINGUAS="
	da de es fr it pl ru sr sv zh zh_TW
"
for lingua in ${QTFM_LINGUAS}; do
	IUSE+=" l10n_${lingua/_/-}"
done

src_prepare() {
	rm translations/${PN}_XX.ts || die

	default

	sed -i \
		-e '/MimeType=/s|$|;|' \
		-e '/Categories=/s|$|;System;FileTools;|' \
		${PN}.desktop || die
}

src_configure() {
	if [[ -n "${L10N}" ]]; then
		local lingua
		for lingua in ${QTFM_LINGUAS}; do
			if ! use l10n_${lingua/_/-}; then
				sed -i -e "s:translations/${PN}_${lingua}.qm::g" ${PN}.pro || die
				rm translations/${PN}_${lingua}.ts || die
			fi
		done
	fi

	lrelease translations/*.ts || die
	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${D}" install

	einstalldocs
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
