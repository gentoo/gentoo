# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

DESCRIPTION="GNU Gettext file parser"

LICENSE="PHP-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ppc64 ~s390 sparc x86"
IUSE=""
PATCHES=( "${FILESDIR/File_Gettext-0.4.2-construct.patch}" )
