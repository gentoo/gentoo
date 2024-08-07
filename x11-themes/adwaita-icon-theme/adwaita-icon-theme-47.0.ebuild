# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson xdg

DESCRIPTION="GNOME default icon theme"
HOMEPAGE="https://gitlab.gnome.org/GNOME/adwaita-icon-theme"

SRC_URI="${SRC_URI}
	branding? ( https://www.mail-archive.com/tango-artists@lists.freedesktop.org/msg00043/tango-gentoo-v1.1.tar.gz )
"
LICENSE="
	|| ( LGPL-3 CC-BY-SA-3.0 )
	branding? ( CC-BY-SA-4.0 )
"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"

IUSE="branding"

# gtk+:3 is needed for build for the gtk-encode-symbolic-svg utility
# librsvg is needed for gtk-encode-symbolic-svg to be able to read the source SVG via
# its pixbuf loader and at runtime for rendering scalable icons shipped by the theme
# adwaita-icon-theme-legacy needed to be FDO compatible (as done in other distributions
# as Fedora:
# https://bugs.gentoo.org/927897
# https://gitlab.gnome.org/GNOME/adwaita-icon-theme/-/issues/288
# https://gitlab.gnome.org/GNOME/adwaita-icon-theme/-/commit/9cb8144b387251eef9c0a221b2febe18802e2435
DEPEND=">=x11-themes/hicolor-icon-theme-0.10"
RDEPEND="${DEPEND}
	>=gnome-base/librsvg-2.48:2
	x11-themes/adwaita-icon-theme-legacy
"
BDEPEND="
	>=gnome-base/librsvg-2.48:2
	sys-devel/gettext
	virtual/pkgconfig
	x11-libs/gtk+:3
"
# This ebuild does not install any binaries
RESTRICT="binchecks strip"

src_prepare() {
	if use branding; then
		for i in 16; do
			cp "${WORKDIR}"/tango-gentoo-v1.1/${i}x${i}/gentoo.png \
			"${S}"/Adwaita/${i}x${i}/places/start-here.png \
			|| die "Copying gentoo logos failed"
		done
		cp "${WORKDIR}"/tango-gentoo-v1.1/scalable/gentoo.svg \
			"${S}"/Adwaita/scalable/places/start-here.svg || die
	fi

	default
}

src_test() {
	:; # No tests
}

src_install() {
	meson_src_install

	# Gentoo uses the following location for cursors too, but keep
	# upstream path to prevent issues like bugs #838451, #834277, #834001
	dosym ../../../../usr/share/icons/Adwaita/cursors /usr/share/cursors/xorg-x11/Adwaita
}

pkg_preinst() {
	# Needed until bug #834600 is solved
	if [[ -d "${EROOT}"/usr/share/cursors/xorg-x11/Adwaita ]] ; then
		rm -r "${EROOT}"/usr/share/cursors/xorg-x11/Adwaita || die
	fi
	xdg_pkg_preinst
}
