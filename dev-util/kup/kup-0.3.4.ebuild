# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="kernel.org uploader tool"
HOMEPAGE="https://www.kernel.org/pub/software/network/kup"
SRC_URI="mirror://kernel/software/network/kup/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-lang/perl
	dev-perl/BSD-Resource
	dev-perl/Config-Simple
"

src_install () {
	dobin kup
	dobin gpg-sign-all
	dobin kup-server
	doman kup.1
	dodoc README
}
