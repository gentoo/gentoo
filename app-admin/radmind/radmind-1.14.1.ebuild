# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/radmind/radmind-1.14.1.ebuild,v 1.5 2015/05/29 21:36:57 mrueg Exp $

EAPI=5

inherit eutils

DESCRIPTION="command-line tools and server to remotely administer multiple Unix filesystems"
HOMEPAGE="http://rsug.itd.umich.edu/software/radmind/"
SRC_URI="mirror://sourceforge/radmind/${P}.tar.gz"

LICENSE="HPND"
SLOT="0"
KEYWORDS="~amd64 x86"

DEPEND="dev-libs/openssl"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.7.0-gentoo.patch
	# remove dnssd as it doesn't compile
	epatch "${FILESDIR}"/${PN}-1.7.1-dnssd.patch
	epatch "${FILESDIR}"/${PN}-1.14.0-parallel-make.patch
}

src_install() {
	default
	dodoc README VERSION COPYRIGHT
}
