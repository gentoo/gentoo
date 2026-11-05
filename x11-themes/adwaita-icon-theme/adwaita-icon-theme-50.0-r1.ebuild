# Copyright 1999-2026 Gentoo Authors
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
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

IUSE="branding"

# librsvg > 2.40 and gtk-4.22 needed at runtime for rendering scalable icons
# shipped by the theme: https://viruta.org/do-not-use-librsvg-2.40.x.html
# adwaita-icon-theme-legacy needed to be FDO compatible:
# https://bugs.gentoo.org/927897
# https://gitlab.gnome.org/GNOME/adwaita-icon-theme/-/issues/288
# https://gitlab.gnome.org/GNOME/adwaita-icon-theme/-/commit/9cb8144b387251eef9c0a221b2febe18802e2435
DEPEND=">=x11-themes/hicolor-icon-theme-0.10"
RDEPEND="${DEPEND}
	|| ( >=gui-libs/gtk-4.22 >=gnome-base/librsvg-2.48:2 )
	x11-themes/adwaita-icon-theme-legacy
"
BDEPEND="
	dev-util/gtk-update-icon-cache
	sys-devel/gettext
	virtual/pkgconfig
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
