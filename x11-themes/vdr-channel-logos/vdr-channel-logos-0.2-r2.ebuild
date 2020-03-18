# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P=${PN#vdr-channel-}-${PV}

DESCRIPTION="Logos for vdr-skin*"
HOMEPAGE="http://www.vdrskins.org/"
SRC_URI="http://www.vdrskins.org/vdrskins/albums/userpics/10138/${MY_P}.tar.gz"

LICENSE="fairuse"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/logos

BDEPEND="app-text/convmv"

_test_charmap() {
	local charmap=$(locale charmap)

	if [ "${charmap}" != "UTF-8" ]; then
		eerror "You need locale UTF-8 to use the logos"
		die "missing locale UTF-8 on your system"
	fi
}

src_prepare() {
	default

	_test_charmap

	convmv --notest --replace -f iso-8859-1 -t utf-8 -r "${S}"/
}

src_install() {
	insinto /usr/share/vdr/channel-logos
	find -maxdepth 1 -name "*.xpm" -print0|xargs -0 cp -a --target="${D}/usr/share/vdr/channel-logos/"
}
