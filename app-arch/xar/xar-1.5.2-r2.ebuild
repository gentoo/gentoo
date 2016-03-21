# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit autotools eutils

DESCRIPTION="An easily extensible archive format"
HOMEPAGE="https://code.google.com/p/xar"
SRC_URI="https://xar.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="acl +bzip2 libressl"

DEPEND="
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	dev-libs/libxml2
	sys-libs/zlib
	acl? ( sys-apps/acl )
	bzip2? ( app-arch/bzip2 )"
RDEPEND="${DEPEND}"

DOCS=( TODO )

src_prepare() {
	epatch "${FILESDIR}/${P}-automagic_acl_and_bzip2.patch"
	epatch "${FILESDIR}/${P}-respect_ldflags.patch"
	epatch_user
	eautoconf
}

src_configure() {
	econf $(use_enable acl) $(use_enable bzip2)
}
