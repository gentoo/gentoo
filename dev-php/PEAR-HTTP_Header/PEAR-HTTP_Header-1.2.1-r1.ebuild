# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
