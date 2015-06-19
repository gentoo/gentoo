# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-HTTP_Header/PEAR-HTTP_Header-1.2.1-r1.ebuild,v 1.4 2015/02/25 15:36:47 ago Exp $

EAPI=5

inherit php-pear-r1

DESCRIPTION="Provides interface to handle and modify HTTP headers and status codes"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RDEPEND="dev-php/PEAR-HTTP"

src_prepare() {
	# Don't install the LICENSE
	sed -i 's~<file baseinstalldir="/" md5sum="b4641eee2eca1a10d4562345a782b4ba" name="LICENSE" role="doc" />~~' \
		"${WORKDIR}"/package.xml || die
}
