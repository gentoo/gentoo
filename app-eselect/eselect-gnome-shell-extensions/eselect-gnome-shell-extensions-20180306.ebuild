# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Manages system defaults for GNOME Shell extensions"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="https://dev.gentoo.org/~leio/distfiles/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"

# gnome-shell schemas are used in pkg_postinst
COMMON_DEPEND="app-admin/eselect
	>=dev-libs/glib-2.26:2
	gnome-base/gsettings-desktop-schemas
	gnome-base/gnome-shell"
RDEPEND="${COMMON_DEPEND}
	dev-lang/perl
	dev-perl/JSON"
DEPEND="${COMMON_DEPEND}
	app-arch/xz-utils"

src_install() {
	insinto "/usr/share/eselect/modules"
	doins gnome-shell-extensions.eselect
	keepdir "/etc/eselect/gnome-shell-extensions"
	# The actual gschema override file will be created in pkg_postinst.
	dosym "../../../../etc/eselect/gnome-shell-extensions/${PN}.gschema.override" \
		"/usr/share/glib-2.0/schemas/${PN}.gschema.override"
}

pkg_postinst() {
	einfo "Updating list of installed extensions"
	eselect gnome-shell-extensions update || die
	local keyname="disabled-extensions"
	has_version ">=gnome-base/gnome-shell-3.1.90" &&
		keyname="enabled-extensions"
	elog
	elog "eselect gnome-shell-extensions manages the system default value of"
	elog "the org.gnome.shell ${keyname} key. To override the default"
	elog "for an individual user, use the gsettings command, e.g."
	elog "\$ gsettings set org.gnome.shell ${keyname} \"['foo', 'bar']\""
	elog "To undo per-user changes and use the system default, do"
	elog "\$ gsettings reset org.gnome.shell ${keyname}"
	elog
}
