# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/crackpkcs12/crackpkcs12-0.2.9.ebuild,v 1.1 2014/09/10 21:09:57 vapier Exp $

EAPI="4"

DESCRIPTION="multithreaded program to crack PKCS#12 files"
HOMEPAGE="http://crackpkcs12.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/openssl"
DEPEND="${RDEPEND}"
