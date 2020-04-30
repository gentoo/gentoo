# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Moves legacy tray icons to top panel"
HOMEPAGE="https://extensions.gnome.org/extension/1031/topicons/"
SRC_URI="https://github.com/phocean/TopIcons-plus/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/TopIcons-plus-${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# glib for glib-compile-schemas at build time, needed at runtime anyways
DEPEND="
	dev-libs/glib:2
"
RDEPEND="${DEPEND}
	app-eselect/eselect-gnome-shell-extensions
	>=gnome-base/gnome-shell-3.34
"
BDEPEND=""

src_install() {
	# TODO: Figure out if we can get the schemas to standard location, in a way that works properly runtime too
	make install INSTALL_PATH="${ED}/usr/share/gnome-shell/extensions/"
	rm "${ED}/usr/share/gnome-shell/extensions/TopIcons@phocean.net/README.md" || die
	# Assuming it needs only compiled gettext catalogs at runtime
	rm "${ED}/usr/share/gnome-shell/extensions/TopIcons@phocean.net/locale"/*/LC_MESSAGES/*.po || die
	dodoc README.md
}

pkg_postinst() {
	ebegin "Updating list of installed extensions"
	eselect gnome-shell-extensions update
	eend $?
}
