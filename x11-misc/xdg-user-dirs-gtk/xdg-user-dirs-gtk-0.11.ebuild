# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome.org readme.gentoo-r1 toolchain-funcs

DESCRIPTION="Integrates xdg-user-dirs into the Gnome desktop and Gtk+ applications"
HOMEPAGE="https://gitlab.gnome.org/GNOME/xdg-user-dirs-gtk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-solaris"

RDEPEND="
	dev-libs/glib:2
	>=x11-libs/gtk+-3.5.1:3
	>=x11-misc/xdg-user-dirs-0.14
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/intltool
	virtual/pkgconfig
"

DOC_CONTENTS="
	This package tries to automatically use some sensible default
	directories for your documents, music, video and other stuff.
	If you want to change those directories to your needs, see
	the settings in ~/.config/user-dirs.dirs
"

src_prepare() {
	default
	sed -i \
		-e '/Encoding/d' \
		-e 's:OnlyShowIn=GNOME;LXDE;Unity;:NotShowIn=KDE;:' \
		user-dirs-update-gtk.desktop.in || die
}

src_configure() {
	local -a myeconfargs=(
		# Skip configure.ac disabling the cross-compiling pkg-config.
		ac_cv_path_PKG_CONFIG="$(tc-getPKG_CONFIG)"
		# Skip searching for this program in the CBUILD root.
		XDG_USER_DIRS_UPDATE="${EPREFIX}/usr/bin/xdg-user-dirs-update"
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
