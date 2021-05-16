# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome2-utils

DESCRIPTION="Control the blur effect on gnome-shell lock screen"
HOMEPAGE="https://github.com/PRATAP-KUMAR/Control_Blur_Effect_On_Lock_Screen"
COMMIT="748b95e931b6b1548b90ceeee7a5883da3e0529f"
SRC_URI="https://github.com/PRATAP-KUMAR/Control_Blur_Effect_On_Lock_Screen/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

# glib for glib-compile-schemas at build time, needed at runtime anyways
COMMON_DEPEND="
	dev-libs/glib:2
"
RDEPEND="${COMMON_DEPEND}
	app-eselect/eselect-gnome-shell-extensions
	>=gnome-base/gnome-shell-3.36.4
"
DEPEND="${COMMON_DEPEND}"
BDEPEND=""

S="${WORKDIR}/Control_Blur_Effect_On_Lock_Screen-${COMMIT}"
extension_uuid="ControlBlurEffectOnLockScreen@pratap.fastmail.fm"

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
