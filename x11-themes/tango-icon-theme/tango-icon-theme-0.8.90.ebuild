# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit gnome2-utils

DESCRIPTION="SVG and PNG icon theme from the Tango project"
HOMEPAGE="http://tango.freedesktop.org"
SRC_URI="http://tango.freedesktop.org/releases/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="minimal png"

RDEPEND="!hppa? ( !minimal? ( x11-themes/gnome-icon-theme ) )
	>=x11-themes/hicolor-icon-theme-0.12"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	>=gnome-base/librsvg-2.34
	|| ( media-gfx/imagemagick[png?] media-gfx/graphicsmagick[imagemagick,png?] )
	sys-devel/gettext
	>=x11-misc/icon-naming-utils-0.8.90"

RESTRICT="binchecks strip"

DOCS="AUTHORS ChangeLog README"

src_prepare() {
	sed -i -e '/svgconvert_prog/s:rsvg:&-convert:' configure || die #413183

	# https://bugs.gentoo.org/472766
	shopt -s nullglob
	cards=$(echo -n /dev/dri/card* | sed 's/ /:/g')
	if test -n "${cards}"; then
		addpredict "${cards}"
	fi
	shopt -u nullglob
}

src_configure() {
	econf \
		$(use_enable png png-creation) \
		$(use_enable png icon-framing)
}

src_install() {
	addwrite /root/.gnome2
	default
}

pkg_preinst() {	gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
