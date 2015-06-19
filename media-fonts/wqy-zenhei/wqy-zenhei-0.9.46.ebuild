# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/wqy-zenhei/wqy-zenhei-0.9.46.ebuild,v 1.2 2015/04/28 10:07:38 yngwin Exp $

EAPI=5
DISABLE_AUTOFORMATTING=true
inherit font readme.gentoo

DESCRIPTION="WenQuanYi Hei-Ti Style (sans-serif) Chinese outline font"
HOMEPAGE="http://wenq.org/wqy2/index.cgi?ZenHei"
SRC_URI="mirror://sourceforge/project/wqy/${PN}-snapshot/${PV}-May/${P}-May.tar.bz2"

LICENSE="GPL-2-with-font-exception"
SLOT="0"
KEYWORDS="amd64 arm ppc ppc64 x86 ~x86-fbsd"
IUSE=""

S="${WORKDIR}/${PN}"
FONT_S="${S}"
FONT_SUFFIX="ttc"
FONT_CONF=(
	43-wqy-zenhei-sharp.conf
	44-wqy-zenhei.conf
)

# Only installs fonts
RESTRICT="binchecks strip test"

DOC_CONTENTS="This font installs two fontconfig configuration files.

To activate preferred rendering, run:
	eselect fontconfig enable 44-wqy-zenhei.conf

To make the font only use embedded bitmap fonts when available, run:
	eselect fontconfig enable 43-wqy-zenhei-sharp.conf"

src_prepare() {
	epatch "${FILESDIR}/44-wqy-zenhei.conf.patch"
}

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
	readme.gentoo_pkg_postinst
}
