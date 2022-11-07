# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..11} )

inherit gnome2 python-any-r1

DESCRIPTION="GNOME default icon theme"
HOMEPAGE="https://gitlab.gnome.org/GNOME/adwaita-icon-theme"

# Rely on Debian workaround until all involved upstreams agree on how to
# fix this: https://gitlab.gnome.org/GNOME/evolution/-/issues/1848
SRC_URI="${SRC_URI/_p*}.tar.xz
	branding? ( https://www.mail-archive.com/tango-artists@lists.freedesktop.org/msg00043/tango-gentoo-v1.1.tar.gz )
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV/_p*}.orig-41.tar.xz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV/_p*}-${PV/*_p}.debian.tar.xz
"
LICENSE="
	|| ( LGPL-3 CC-BY-SA-3.0 )
	branding? ( CC-BY-SA-4.0 )
"
SLOT="0"
IUSE="branding"
KEYWORDS="amd64 arm arm64 ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux"

# gtk+:3 is needed for build for the gtk-encode-symbolic-svg utility
# librsvg is needed for gtk-encode-symbolic-svg to be able to read the source SVG via its pixbuf loader and at runtime for rendering scalable icons shipped by the theme
DEPEND=">=x11-themes/hicolor-icon-theme-0.10"
RDEPEND="${DEPEND}
	>=gnome-base/librsvg-2.48:2
"
BDEPEND="${PYTHON_DEPS}
	>=gnome-base/librsvg-2.48:2
	sys-devel/gettext
	virtual/pkgconfig
	x11-libs/gtk+:3
"
# This ebuild does not install any binaries
RESTRICT="binchecks strip"

S="${WORKDIR}/${P/_p*}"

src_prepare() {
	if use branding; then
		for i in 16 22 24 32 48; do
			cp "${WORKDIR}"/tango-gentoo-v1.1/${i}x${i}/gentoo.png \
			"${S}"/Adwaita/${i}x${i}/places/start-here.png \
			|| die "Copying gentoo logos failed"
		done
		cp "${WORKDIR}"/tango-gentoo-v1.1/scalable/gentoo.svg \
			"${S}"/Adwaita/scalable/places/start-here.svg || die
	fi

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure GTK_UPDATE_ICON_CACHE=$(type -P true)
	einfo "Configuring legacy icons"
	cd "${WORKDIR}/${PN}-41.0" && gnome2_src_configure GTK_UPDATE_ICON_CACHE=$(type -P true)
}

src_compile() {
	gnome2_src_compile
	einfo "Compiling legacy icons"
	cd "${WORKDIR}/${PN}-41.0" && gnome2_src_compile
}

pkg_preinst() {
	# Needed until bug #834600 is solved
	if [[ -d "${EROOT}"/usr/share/cursors/xorg-x11/Adwaita ]] ; then
		rm -r "${EROOT}"/usr/share/cursors/xorg-x11/Adwaita || die
	fi
}

src_install() {
	gnome2_src_install

	# Gentoo uses the following location for cursors too, but keep
	# upstream path to prevent issues like bugs #838451, #834277, #834001
	dosym ../../../../usr/share/icons/Adwaita/cursors /usr/share/cursors/xorg-x11/Adwaita

	# Install missing icons, bug #844910
	# https://gitlab.gnome.org/GNOME/evolution/-/issues/1848
	einfo "Installing legacy icons"
	cd "${WORKDIR}/${PN}-41.0"
	emake DESTDIR="${WORKDIR}/debian/tmp-41" install
	"${PYTHON}" "${WORKDIR}/debian/move-subset.py" \
		--icon-names-from-file="${WORKDIR}"/debian/legacy-icons-41.txt \
		--icon-names-from-file="${WORKDIR}"/debian/removed-icons-41.txt \
		"${WORKDIR}"/debian/tmp-41 \
		"${ED}" || die
}
