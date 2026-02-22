# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop flag-o-matic xdg

DESCRIPTION="A GUI for cupsd"
HOMEPAGE="https://gtklp.sirtobi.com/"
SRC_URI="
	https://downloads.sourceforge.net/project/${PN}/${PN}/${PV}/${P}.src.tar.gz
	https://downloads.sourceforge.net/project/${PN}/enhancements/icons/logo.xpm.gz -> ${PN}-logo.xpm.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE="nls ssl"

RDEPEND="
	net-print/cups
	x11-libs/gtk+:2
	nls? ( sys-devel/gettext )
	ssl? ( dev-libs/openssl:0= )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}/${P}-formatsec.patch" )

src_prepare() {
	default
	sed -e '/DEF_BROWSER_CMD/{s:netscape:firefox:}' \
		-e '/DEF_HELP_HOME/{s:631/sum.html#STANDARD_OPTIONS:631/help/:}' \
		-i include/defaults.h || die
	eautoreconf
}

src_configure() {
	append-cflags -fcommon
	econf \
		$(use_enable nls) \
		$(use_enable ssl) \
		--enable-forte #369003
}

src_install() {
	default

	dodoc USAGE
	doicon "${WORKDIR}"/"${PN}"-logo.xpm
	make_desktop_entry 'gtklp -i' "${PN} -- Print files via CUPS" "${PN}"-logo 'System;HardwareSettings;Settings;Printing'
	make_desktop_entry "${PN}"q "${PN}q -- CUPS queue manager" "${PN}"-logo 'System;HardwareSettings;Settings;Printing'
}
