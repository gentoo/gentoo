# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# USE="-* gtk2 gtk3 xfce" ebuild ${P}.ebuild clean compile
# cd ~portage/x11-themes/${P}/work
# make -j -C */common/gtk-3.0/3.18
# find */common/{gtk-2.0,gtk-3.0/3.*,xfwm4} -name "*.png" ! -path "*/menubar-toolbar/*" | xargs tar Jcvf /usr/portage/distfiles/${P}-pngs.tar.xz --owner=root --group=root

inherit autotools

DESCRIPTION="A flat theme with transparent elements for GTK+3, GTK+2 and GNOME Shell"
HOMEPAGE="https://github.com/jnsh/arc-theme"
SRC_URI="https://github.com/jnsh/${PN}/releases/download/${PV}/arc-theme-${PV}.tar.xz
	pre-rendered? ( https://dev.gentoo.org/~chewi/distfiles/${P}-pngs.tar.xz )"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc64 ~x86"
IUSE="cinnamon gnome-shell +gtk2 +gtk3 mate +pre-rendered xfce"

SASSC_DEPEND="
	dev-lang/sassc
"

SVG_DEPEND="
	!pre-rendered? (
		media-gfx/inkscape
		media-gfx/optipng
	)
"

# Supports various GTK+3 versions and uses pkg-config to determine which
# set of files to install. Updates will break it but only this fix will
# help. See https://github.com/horst3180/arc-theme/pull/436. The same
# applies to GNOME Shell and Cinnamon but I don't know whether those are
# fixable.
BDEPEND="
	cinnamon? (
		${SASSC_DEPEND}
		gnome-extra/cinnamon
	)
	gnome-shell? (
		${SASSC_DEPEND}
		>=gnome-base/gnome-shell-3.18
	)
	gtk2? (
		${SVG_DEPEND}
	)
	gtk3? (
		${SASSC_DEPEND}
		${SVG_DEPEND}
		virtual/pkgconfig
		>=x11-libs/gtk+-3.18:3
	)
	xfce? (
		${SVG_DEPEND}
	)
"

# gnome-themes-standard is only needed by GTK+2 for the Adwaita
# engine. This engine is built into GTK+3.
RDEPEND="
	gtk2? (
		x11-themes/gnome-themes-standard
		x11-themes/gtk-engines-murrine
	)
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	use pre-rendered &&
		export INKSCAPE="${BROOT}"/bin/false OPTIPNG="${BROOT}"/bin/false

	econf \
		--disable-plank \
		--disable-unity \
		$(use_enable cinnamon) \
		$(use_enable gtk2) \
		$(use_enable gtk3) \
		$(use_enable gnome-shell) \
		$(use_enable mate metacity) \
		$(use_enable xfce xfwm)
}

src_compile() {
	# fontconfig issue?
	# https://bugs.gentoo.org/666418#c28
	use pre-rendered ||
		addpredict "${BROOT}"/usr/share/inkscape/fonts/.uuid.TMP-XXXXXX

	default
}
