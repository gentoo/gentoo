# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit php-pear-r2

DESCRIPTION="Object-oriented PHP5 resolver library used to communicate with a DNS server"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-php/PEAR-PEAR >=dev-lang/php-5.3:*[sockets]"

DOCS=( README.md )
