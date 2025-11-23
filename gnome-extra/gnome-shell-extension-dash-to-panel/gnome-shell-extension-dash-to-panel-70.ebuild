# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome2-utils

MY_PN="${PN/gnome-shell-extension-/}"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="An icon taskbar for the Gnome Shell"
HOMEPAGE="https://github.com/home-sweet-gnome/dash-to-panel"
SRC_URI="
	https://github.com/home-sweet-gnome/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	branding? ( https://www.mail-archive.com/tango-artists@lists.freedesktop.org/msg00043/tango-gentoo-v1.1.tar.gz )
"
S="${WORKDIR}/${MY_P}"
extension_uuid="dash-to-panel@jderose9.github.com"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"
IUSE="branding"

COMMON_DEPEND="dev-libs/glib:2"
RDEPEND="${COMMON_DEPEND}
	app-eselect/eselect-gnome-shell-extensions
	>=gnome-base/gnome-shell-46
"
DEPEND="${COMMON_DEPEND}"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
"

src_prepare() {
	default

	# Set correct version
	export VERSION="${PV}"

	# Don't install README and COPYING in unwanted locations
	sed -i -e 's/COPYING//g' -e 's/README.md//g' Makefile || die

	# Provide fancy Gentoo icon when requested
	use branding && eapply "${FILESDIR}"/${PN}-26-branding.patch
}

src_install() {
	default
	if use branding; then
		insinto /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/img
		doins "${WORKDIR}/tango-gentoo-v1.1/scalable/gentoo.svg"
	fi
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
