# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Adds special features for media files to the Thunar File Manager"
HOMEPAGE="https://goodies.xfce.org/projects/thunar-plugins/thunar-media-tags-plugin"
SRC_URI="https://archive.xfce.org/src/thunar-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=media-libs/taglib-1.6
	>=x11-libs/gtk+-2.12:2
	>=xfce-base/exo-0.6
	<xfce-base/thunar-1.7"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
