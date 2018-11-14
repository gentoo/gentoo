# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="General-purpose console screen reader"
HOMEPAGE="http://yasr.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="nls"

RDEPEND=""
DEPEND="nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.6.9-automake113.patch
	"${FILESDIR}"/${PN}-0.6.9-gettext019.patch
	"${FILESDIR}"/${PN}-0.6.9-gcc43.patch
	"${FILESDIR}"/${PN}-0.6.9-remove-m4.patch
)

src_prepare() {
	default
	local x=/usr/share/gettext/po/Makefile.in.in
	[[ -e $x ]] && cp -f $x po/ || die #330879

	rm -r "${S}"/m4 || die

	sed -i \
	's:^\(synthesizer=emacspeak server\):#\1:
	s:^\(synthesizer port=|/usr/local/bin/eflite\):#\1:
	s:^#\(synthesizer=speech dispatcher\):\1:
	s:^#\(synthesizer port=127.0.0.1.6560\):\1:' yasr.conf || die

	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	econf \
		--datadir="${EPREFIX}"/etc \
		$(use_enable nls)
}

pkg_postinst() {
	elog
	elog "Speech-dispatcher is configured as the default synthesizer for yasr."
	elog "If this is not what you want, edit /etc/yasr/yasr.conf."
}
