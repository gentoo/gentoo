# Copyright 2007-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISABLE_AUTOFORMATTING=true
inherit font readme.gentoo-r1

DESCRIPTION="WenQuanYi Hei-Ti Style (sans-serif) Chinese outline font"
HOMEPAGE="http://wenq.org/wqy2/index.cgi?ZenHei"
SRC_URI="mirror://sourceforge/project/wqy/${PN}-snapshot/${PV}-May/${P}-May.tar.bz2"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2-with-font-exception"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ppc ppc64 x86"
IUSE=""

# Only installs fonts
RESTRICT="binchecks strip test"

FONT_CONF=(
	43-wqy-zenhei-sharp.conf
	44-wqy-zenhei.conf
)
FONT_SUFFIX="ttc"

DOC_CONTENTS="This font installs two fontconfig configuration files.

To activate preferred rendering, run:
	eselect fontconfig enable 44-wqy-zenhei.conf

To make the font only use embedded bitmap fonts when available, run:
	eselect fontconfig enable 43-wqy-zenhei-sharp.conf"

PATCHES=( "${FILESDIR}/44-wqy-zenhei.conf.patch" )

src_compile() {
	:
}

src_install() {
	font_src_install
	readme.gentoo_create_doc
}

pkg_postinst() {
	unset FONT_CONF # override default message
	font_pkg_postinst
	readme.gentoo_print_elog
}
