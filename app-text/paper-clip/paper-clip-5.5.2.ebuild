# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

APP_PN="Paper-Clip"

inherit gnome2-utils meson vala xdg

DESCRIPTION="Edit the title, author, keywords and more details of PDF documents"
HOMEPAGE="https://github.com/Diego-Ivan/Paper-Clip/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/Diego-Ivan/${APP_PN}.git"
else
	SRC_URI="https://github.com/Diego-Ivan/${APP_PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"
	S="${WORKDIR}/${APP_PN}-${PV}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"
RESTRICT="test"  # Only validations, the appdata one fails.

RDEPEND="
	>=gui-libs/gtk-4.12.5:4
	>=gui-libs/libadwaita-1.5.0:1[introspection,vala]
	app-text/poppler:=[cairo,introspection]
	dev-libs/glib:2
	dev-libs/gobject-introspection
	dev-libs/libportal:=[gtk,introspection,vala]
	media-libs/exempi
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	$(vala_depend)
	dev-libs/appstream-glib
	dev-util/desktop-file-utils
"

DOCS=( README.md )

src_prepare() {
	default
	vala_setup
}

src_install() {
	meson_src_install
	einstalldocs

	# Symlink "pdf-metadata-editor" (old name?) to "${PN}".
	dosym -r /usr/bin/pdf-metadata-editor "/usr/bin/${PN}"
}

pkg_postinst() {
	gnome2_schemas_update
	xdg_pkg_postinst
}

pkg_postrm() {
	gnome2_schemas_update
	xdg_pkg_postrm
}
