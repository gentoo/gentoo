# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome2-utils meson

MY_PN="ding"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Fork from the desktop-icons project, with several enhancements like Drag'n'Drop"
HOMEPAGE="https://gitlab.com/rastersoft/desktop-icons-ng"
SRC_URI="https://gitlab.com/rastersoft/desktop-icons-ng/uploads/a434978b57ec46ad0e35352b27d525c6/${MY_P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND="dev-libs/glib:2"
RDEPEND="${COMMON_DEPEND}
	app-eselect/eselect-gnome-shell-extensions
	>=gnome-base/gnome-shell-3.38
	>=gnome-base/nautilus-3.38
"
DEPEND="${COMMON_DEPEND}"
BDEPEND=""

S="${WORKDIR}/${MY_P}"
extension_uuid="ding@rastersoft.com"

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
