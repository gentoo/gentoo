# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="xbase (i.e. dBase, FoxPro, etc.) compatible C++ class library"
HOMEPAGE="https://sourceforge.net/projects/xdb/ http://linux.techass.com/projects/xdb/"
SRC_URI="mirror://sourceforge/xdb/${PN}64-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm hppa ppc ppc64 x86"
IUSE="doc static-libs"

S="${WORKDIR}"/${PN}64-${PV}

PATCHES=(
	"${FILESDIR}"/${P}-fixconfig.patch
	"${FILESDIR}"/${P}-gcc44.patch
	"${FILESDIR}"/${PN}-2.0.0-ppc.patch
	"${FILESDIR}"/${P}-xbnode.patch
	"${FILESDIR}"/${P}-lesserg.patch
	"${FILESDIR}"/${P}-outofsource.patch
	"${FILESDIR}"/${P}-gcc47.patch
	"${FILESDIR}"/${P}-gcc-version.patch
	"${FILESDIR}"/${P}-gcc6.patch
	"${FILESDIR}"/${P}-gcc7.patch
)

src_prepare() {
	default
	mv configure.in configure.ac || die
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	if use doc; then
		HTML_DOCS+=( html/. )
		if [[ -e examples/.libs ]] ; then
			rm -r examples/.libs || die
		fi
		dodoc -r examples
	fi

	default
	find "${D}" -name '*.la' -delete || die

	if use doc; then
		rm "${ED%/}"/usr/share/doc/${PF}/html/copying.lib || die
		rm "${ED%/}"/usr/share/doc/${PF}/html/Makefile{,.in,.am} || die
	fi

	# media-tv/linuxtv-dvb-apps collision, bug #208596
	mv "${ED%/}"/usr/bin/{,${PN}-}zap || die
}
