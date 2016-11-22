# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
ESVN_PROJECT=g15tools/trunk
ESVN_REPO_URI="https://svn.code.sf.net/p/g15tools/code/trunk/${PN}"

inherit subversion base eutils autotools

DESCRIPTION="Small library for display text and graphics on a Logitech G15 keyboard"
HOMEPAGE="http://g15tools.sourceforge.net/"
[[ $PV = *9999* ]] || SRC_URI="mirror://sourceforge/g15tools/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

IUSE="truetype"

RDEPEND="
	dev-libs/libg15
	truetype? ( media-libs/freetype )
"
DEPEND=${RDEPEND}

src_unpack() {
	if [[ ${PV} = *9999* ]]; then
		subversion_src_unpack
	fi
}

src_prepare() {
	# Merged upstream
	#epatch "${FILESDIR}/${PN}-1.2-pixel-c.patch"

	if [[ ${PV} = *9999* ]]; then
		subversion_wc_info
	fi
	base_src_prepare
	if [[ ${PV} = *9999* ]]; then
		eautoreconf
	fi
}

src_configure() {
	econf \
		--disable-static \
		$(use_enable truetype ttf )
}

src_install() {
	emake DESTDIR="${D}" \
		docdir=/usr/share/doc/${PF} install || die "make install failed"
	rm "${ED}/usr/share/doc/${PF}/COPYING"

	find "${ED}" -name '*.la' -exec rm -f {} +
}
