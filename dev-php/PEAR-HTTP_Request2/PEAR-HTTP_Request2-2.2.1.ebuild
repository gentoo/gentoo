# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit php-pear-r1

DESCRIPTION="Provides an easy way to perform HTTP requests"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~ppc ~ppc64 ~s390 ~sh sparc x86"
IUSE="+curl +fileinfo +ssl +zlib"

RDEPEND="dev-lang/php[curl?,fileinfo?,ssl?,zlib?]
>=dev-php/PEAR-Net_URL2-2.0.0"
