# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg

MY_PN=${PN}2
MY_P=${MY_PN}-${PV}

DESCRIPTION="GTK+ music manager for the Portable Digital Entertainment (PDE) protocol"
HOMEPAGE="https://gnomad2.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="nls"

RDEPEND="
	dev-libs/libgudev:=
	media-libs/libid3tag:=
	media-libs/libmtp:=
	media-libs/libnjb
	media-libs/taglib:=
	>=x11-libs/gtk+-2.24:2
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	nls? (
		dev-util/intltool
		sys-devel/gettext
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.9.6-fno-common.patch
	"${FILESDIR}"/${PN}-2.9.6-c99.patch
)

DOCS=( AUTHORS README TODO ) # ChangeLog and NEWS are both outdated

src_configure() {
	econf $(use_enable nls)
}
