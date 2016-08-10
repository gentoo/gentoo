# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="git://subsurface.hohndel.org/subsurface.git"
	GIT_ECLASS="git-2"
	LIBDC_V="0.4.1"
else
	SRC_URI="http://subsurface.hohndel.org/downloads/Subsurface-${PV}.tgz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	LIBDC_V="0.4.1"
	S="${WORKDIR}/${P/s/S}"
fi

inherit eutils gnome2-utils ${GIT_ECLASS}

LINGUAS="bg bg_BG br ca ca_ES da_DK de de_CH de_DE da ee es es_ES et_EE fi fi_FI fr fr_FR gsw hr
	hr_HR it it_IT nb nb_NO nl nl_NL nn no pl pl_PL pt pt_BR pt_PT ru ru_RU sk sk_SK sv sv_SE"

DESCRIPTION="An open source dive log program"
HOMEPAGE="http://subsurface.hohndel.org"
LICENSE="GPL-2"
SLOT="0"
IUSE="doc usb"
for LINGUA in ${LINGUAS}; do
	IUSE+=" linguas_${LINGUA}"
done

RDEPEND="dev-db/sqlite:3
	dev-libs/glib:2
	dev-libs/libxml2
	dev-libs/libxslt
	dev-libs/libzip
	gnome-base/gconf:2
	sci-geosciences/osm-gps-map:2
	net-libs/libsoup:2.4
	virtual/libusb
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	x11-libs/pango
"
DEPEND="${RDEPEND}
	>=dev-libs/libdivecomputer-${LIBDC_V}[static-libs,usb?]
	virtual/pkgconfig
	doc? ( app-text/asciidoc )
"

src_unpack() {
	if [[ ${PV} = *9999* ]]; then
		git-2_src_unpack
	else
		unpack ${A}
	fi
}

src_prepare() {
	# Don't hardcode gcc.
	sed -i 's|CC\=gcc||' Makefile || die "Failed to fix gcc hardcode issues."

	# Don't hardcode CFLAGS.
	sed -i 's|CFLAGS\=.*||' Makefile || die "Failed to fix hardcoded CFLAGS."

	# Don't call gtk_update_icon_cache.
	sed -i -e "s|\$(gtk_update_icon_cache)|:|" Makefile || die "Failed to disable gtk_update_icon_cache call."
}

src_compile() {
	emake CC="$(tc-getCC)"

	if use doc; then
		cd "Documentation" && emake user-manual.xhtml
	fi
}

src_install() {
	emake DESTDIR="${D}" CC="$(tc-getCC)" install

	# Remove unwanted linguas
	local del
	for LANG in $(ls "${D}/usr/share/locale"); do
		del=1
		for LINGUA in ${LINGUAS}; do
			if [[ ${LANG/.UTF-8/} == ${LINGUA} ]]; then
				if use linguas_${LINGUA}; then
					del=0
				fi
				break
			fi
		done
		if [[ ${del} == 1 ]]; then
			rm -r "${D}/usr/share/locale/${LANG}" || die "Removing language ${LANG} failed."
		fi
	done

	if use doc; then
		dohtml -r "${S}/Documentation/"
	fi
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
