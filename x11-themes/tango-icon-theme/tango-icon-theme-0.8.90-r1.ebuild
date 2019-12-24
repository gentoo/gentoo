# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg

DESCRIPTION="SVG and PNG icon theme from the Tango project"
HOMEPAGE="http://tango.freedesktop.org"
SRC_URI="http://tango.freedesktop.org/releases/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="minimal png"
RESTRICT="binchecks strip"

RDEPEND="!hppa? ( !minimal? ( x11-themes/adwaita-icon-theme ) )
	>=x11-themes/hicolor-icon-theme-0.12"
BDEPEND="
	dev-util/intltool
	gnome-base/librsvg
	sys-devel/gettext
	virtual/imagemagick-tools[png?]
	virtual/pkgconfig
	x11-misc/icon-naming-utils"

PATCHES=(
	# https://bugs.gentoo.org/413183
	"${FILESDIR}"/${PN}-0.8.90-rsvg-convert.patch
)

src_prepare() {
	xdg_src_prepare

	# https://bugs.gentoo.org/472766
	local d
	for d in /dev/dri/card*; do
		[[ -s ${d} ]] && addpredict "${d}"
	done
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
