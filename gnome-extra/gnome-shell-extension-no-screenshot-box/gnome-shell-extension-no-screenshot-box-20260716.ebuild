# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2-utils

DESCRIPTION="Customize the GNOME Shell screenshot area selector"
HOMEPAGE="https://github.com/abdallah-alkanani/no-screenshot-box"
COMMIT="049690c3a003afd005fad5459f783ba3f46cdb81"
SRC_URI="https://github.com/abdallah-alkanani/no-screenshot-box/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

extension_uuid="no-screenshot-box@screenshot"
S="${WORKDIR}/no-screenshot-box-${COMMIT}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

# glib for glib-compile-schemas at build time, needed at runtime anyways
COMMON_DEPEND="
	dev-libs/glib:2
"
RDEPEND="${COMMON_DEPEND}
	app-eselect/eselect-gnome-shell-extensions
	>=gnome-base/gnome-shell-45
"
DEPEND="${COMMON_DEPEND}"

src_compile() { :; }

src_install() {
	einstalldocs
	insinto /usr/share/glib-2.0/schemas
	doins schemas/*.xml
	rm -rf LICENSE README.md schemas
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
