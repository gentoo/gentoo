# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/unshield/unshield-0.6_p20120308.ebuild,v 1.6 2013/05/15 22:40:01 ssuominen Exp $

EAPI=4
inherit autotools eutils

DESCRIPTION="InstallShield CAB file extractor"
HOMEPAGE="http://github.com/twogood/unshield http://sourceforge.net/projects/synce/"
SRC_URI="mirror://gentoo/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc x86"
IUSE="static-libs"

RDEPEND="dev-libs/openssl:0
	sys-libs/zlib"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-bootstrap.patch
	./bootstrap
	sed -i -e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' configure.ac || die #467548
	AT_M4DIR=m4 eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		--with-ssl
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README

	find "${D}" -name '*.la' -exec rm -f {} +
}
