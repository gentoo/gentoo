# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit autotools base eutils

DESCRIPTION="An easily extensible archive format"
HOMEPAGE="http://code.google.com/p/xar"
SRC_URI="http://xar.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~ppc ~ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="acl +bzip2"

DEPEND="dev-libs/openssl
	dev-libs/libxml2
	sys-libs/zlib
	acl? ( sys-apps/acl )
	bzip2? ( app-arch/bzip2 )"
RDEPEND="${DEPEND}"

DOCS=( TODO )
PATCHES=( "${FILESDIR}/${P}-automagic_acl_and_bzip2.patch"
	"${FILESDIR}/${P}-respect_ldflags.patch" )

src_prepare() {
	base_src_prepare
	eautoconf
}

src_configure() {
	econf $(use_enable acl) $(use_enable bzip2)
}
