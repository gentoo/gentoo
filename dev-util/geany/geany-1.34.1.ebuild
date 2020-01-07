# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils xdg-utils

LANGS="ar ast be bg ca cs de el en_GB es et eu fa fi fr gl he hi hu id it ja kk ko lb lt mn nl nn pl pt pt_BR ro ru sk sl sr sv tr uk vi zh_CN ZH_TW"
NOSHORTLANGS="en_GB zh_CN zh_TW"

DESCRIPTION="GTK+ based fast and lightweight IDE"
HOMEPAGE="https://www.geany.org"
if [[ "${PV}" = 9999* ]] ; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://github.com/geany/geany.git"
else
	SRC_URI="https://download.geany.org/${P}.tar.bz2"
	KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
fi
LICENSE="GPL-2+ HPND"
SLOT="0"

IUSE="+gtk3 +vte"

RDEPEND=">=dev-libs/glib-2.32:2
	!gtk3? (
		>=x11-libs/gtk+-2.24:2
		vte? ( x11-libs/vte:0 )
	)
	gtk3? (
		>=x11-libs/gtk+-3.0:3
		vte? ( x11-libs/vte:2.91 )
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-util/intltool
	sys-devel/gettext"

pkg_setup() {
	strip-linguas ${LANGS}
}

src_prepare() {
	default

	# Syntax highlighting for Portage
	sed -i -e "s:*.sh;:*.sh;*.ebuild;*.eclass;:" \
		data/filetype_extensions.conf || die

	if [[ ${PV} = *_pre* ]] || [[ ${PV} = 9999* ]] ; then
		eautoreconf
	fi
}

src_configure() {
	local myeconfargs=(
		--disable-html-docs
		--disable-dependency-tracking
		--disable-pdf-docs
		--docdir="${EPREFIX}/usr/share/doc/${PF}"
		$(use_enable gtk3)
		$(use_enable vte)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" install
	find "${ED}" \( -name '*.a' -o -name '*.la' \) -delete || die
}

pkg_preinst() { gnome2_icon_savelist; }

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}
