# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit vcs-snapshot

DESCRIPTION="Moves legacy tray icons to top panel"
HOMEPAGE="https://extensions.gnome.org/extension/1031/topicons/"
SRC_URI="https://github.com/phocean/TopIcons-plus/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

# glib for glib-compile-schemas at build time, needed at runtime anyways
COMMON_DEPEND="
	dev-libs/glib:2
"
RDEPEND="${COMMON_DEPEND}
	app-eselect/eselect-gnome-shell-extensions
	>=gnome-base/gnome-shell-3.16
"
DEPEND="${COMMON_DEPEND}"

PATCHES=(
	# https://github.com/phocean/TopIcons-plus/commit/e883e62a36c342bdf2e31af9d328b10f4ce61112
	"${FILESDIR}"/${P}-exit-stacktrace.patch
)

#src_compile() {
	# It redoes this with "make install" later due to a dumb Makefile, so don't bother
	#make build
#}

src_install() {
	# TODO: Figure out if we can get the schemas to standard location, in a way that works properly runtime too
	make install INSTALL_PATH="${ED}usr/share/gnome-shell/extensions/"
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
