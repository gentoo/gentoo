# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnustep-2

MY_PN=PictureFrame
DESCRIPTION="digital picture frame software"
HOMEPAGE="http://www.nongnu.org/gap/pictureframe/index.html"
SRC_URI="http://ftp.gnustep.org/pub/gnustep/contrib/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

S=${WORKDIR}/${MY_PN}-${PV}

src_install() {
	gnustep-base_src_install
	dodoc PICTURE_FRAMES README
}
