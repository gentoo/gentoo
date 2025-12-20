# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GNOME_ORG_MODULE="murrine"

inherit gnome.org multilib-minimal

DESCRIPTION="Murrine GTK+2 Cairo Engine"
HOMEPAGE="https://tracker.debian.org/pkg/gtk2-engines-murrine"

LICENSE="LGPL-2.1 LGPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~loong ppc ppc64 ~riscv x86"
IUSE="+themes animation-rtl"

RDEPEND=">=x11-libs/gtk+-2.24.23:2[${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}]
	>=x11-libs/gdk-pixbuf-2.30.7:2[${MULTILIB_USEDEP}]
	>=x11-libs/cairo-1.12.14-r4[${MULTILIB_USEDEP}]
	>=x11-libs/pango-1.36.3[${MULTILIB_USEDEP}]
	>=x11-libs/pixman-0.32.4[${MULTILIB_USEDEP}]"
PDEPEND="themes? ( x11-themes/murrine-themes )"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-util/intltool-0.37.1
	sys-devel/gettext
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/0.98.2-implicit-functions.patch
)

DOCS=( AUTHORS ChangeLog NEWS TODO )

src_prepare() {
	default
	# Linking fix, in next release (commit 6e8eb244). Sed to avoid eautoreconf.
	sed -e 's:\($(GTK_LIBS) $(pixman_LIBS)\)$:\1 -lm:' \
		-i Makefile.* || die "sed failed"
}

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	econf --enable-animation \
		--enable-rgba \
		$(use_enable animation-rtl animationrtl)
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}
