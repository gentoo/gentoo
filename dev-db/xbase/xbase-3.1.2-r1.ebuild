# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

DESCRIPTION="xbase (i.e. dBase, FoxPro, etc.) compatible C++ class library"
HOMEPAGE="http://linux.techass.com/projects/xdb/"
SRC_URI="mirror://sourceforge/xdb/${PN}64-${PV}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE="doc static-libs"

S="${WORKDIR}"/${PN}64-${PV}

PATCHES=(
	"${FILESDIR}/${P}-fixconfig.patch"
	"${FILESDIR}/${P}-gcc44.patch"
	"${FILESDIR}/${PN}-2.0.0-ppc.patch"
	"${FILESDIR}/${P}-xbnode.patch"
	"${FILESDIR}/${P}-lesserg.patch"
	"${FILESDIR}/${P}-outofsource.patch"
	"${FILESDIR}/${P}-gcc47.patch"
	"${FILESDIR}/${P}-gcc-version.patch"
	"${FILESDIR}/${P}-cpp14.patch" # bug #594174
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	if use doc; then
		HTML_DOCS+=( html/. )
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi

	default

	# media-tv/linuxtv-dvb-apps collision, bug #208596
	mv "${ED%/}"/usr/bin/{,${PN}-}zap || die
}
