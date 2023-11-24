# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome2-utils

# Useful specially to prevent
# https://gitlab.gnome.org/GNOME/gnome-shell/-/issues/4684
# https://gitlab.gnome.org/GNOME/gnome-shell/-/issues/3180
DESCRIPTION="Restore the alphabetical ordering of the app grid"
HOMEPAGE="https://github.com/stuarthayhurst/alphabetical-grid-extension"
SRC_URI="https://github.com/stuarthayhurst/alphabetical-grid-extension/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	app-eselect/eselect-gnome-shell-extensions
	>=gnome-base/gnome-shell-45
	gui-libs/libadwaita
"
DEPEND="${COMMON_DEPEND}"

S="${WORKDIR}/alphabetical-grid-extension-${PV}"
extension_uuid="AlphabeticalAppGrid@stuarthayhurst"

# Tests are only useful for upstream
RESTRICT="test"

# Not useful for us
src_compile() { :; }

src_install() {
	einstalldocs
	mv docs/icon.svg extension || die
	cd extension || die
	insinto /usr/share/glib-2.0/schemas
	doins schemas/*.xml
	rm -rf schemas || die
	insinto /usr/share/gnome-shell/extensions/"${extension_uuid}"
	doins -r *
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
	ebegin "Updating list of installed extensions"
	eselect gnome-shell-extensions update
	eend $?
}

pkg_postrm() {
	gnome2_schemas_update
}
