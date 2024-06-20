# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit php-pear-r2

DESCRIPTION="PHP class interface to TCP sockets"
LICENSE="BSD-2"

SLOT="0"
KEYWORDS="~amd64 arm ~hppa ~ppc64 ~s390 ~sparc ~x86"

RDEPEND=">=dev-php/PEAR-PEAR-1.10.1"
