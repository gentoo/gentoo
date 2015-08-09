# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit php-pear-r1

DESCRIPTION="Lets you manipulate easily the tar, gz, tgz, bz2, tbz, zip, ar (or deb) files"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="minimal"
RDEPEND="dev-lang/php[bzip2,zlib]
	dev-php/PEAR-MIME_Type
	!minimal? ( dev-php/PEAR-Mail_Mime
		dev-php/PEAR-Mail
		>=dev-php/PEAR-Cache_Lite-1.5.0 )"
