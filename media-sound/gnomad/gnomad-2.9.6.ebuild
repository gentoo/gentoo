# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN=${PN}2
MY_P=${MY_PN}-${PV}

DESCRIPTION="A GTK+ music manager for the Portable Digital Entertainment (PDE) protocol"
HOMEPAGE="http://gnomad2.sourceforge.net/"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="nls"

RDEPEND="
	dev-libs/libgudev:=
	media-libs/libid3tag
	media-libs/libmtp
	media-libs/libnjb
	media-libs/taglib
	>=x11-libs/gtk+-2.24:2"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	nls? (
		dev-util/intltool
		sys-devel/gettext
	)"

S=${WORKDIR}/${MY_P}

PATCHES=( "${FILESDIR}"/${PN}-2.9.6-fno-common.patch )
DOCS=( AUTHORS README TODO ) # ChangeLog and NEWS are both outdated

src_configure() {
	econf $(use_enable nls)
}
