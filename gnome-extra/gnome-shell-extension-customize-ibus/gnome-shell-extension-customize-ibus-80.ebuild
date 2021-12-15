# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome2-utils

DESCRIPTION="Full customization of appearance, behavior, system tray and input source indicator for IBus"
HOMEPAGE="https://github.com/openSUSE/Customize-IBus"
SRC_URI="https://github.com/openSUSE/Customize-IBus/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~ppc64 ~riscv x86"
IUSE=""

BDEPEND="
	dev-libs/glib:2
	sys-devel/gettext
	app-eselect/eselect-gnome-shell-extensions
	>=gnome-base/gnome-shell-3.34
"
RDEPEND="
	app-i18n/ibus
	${BDEPEND}
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/Customize-IBus-${PV}"
extension_uuid="customize-ibus@hollowman.ml"

src_compile() {
	emake _build VERSION=${PV} || die "failed to build"
}

src_install() {
	einstalldocs
	rm -f README.md LICENSE
	insinto /usr/share/glib-2.0/schemas
	doins _build/schemas/*.xml
	rm -rf _build/schemas/*.xml
	insinto /usr/share/gnome-shell/extensions/"${extension_uuid}"
	doins -r _build/*
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
