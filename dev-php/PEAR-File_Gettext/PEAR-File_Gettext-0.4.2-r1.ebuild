# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

DESCRIPTION="GNU Gettext file parser"

LICENSE="PHP-3"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ppc ppc64 ~s390 sparc x86"
IUSE=""
PATCHES=( "${FILESDIR/File_Gettext-0.4.2-construct.patch}" )
