# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_PHP="php5-6 php7-0 php7-1"

inherit php-ext-pecl-r3

KEYWORDS="~amd64 ~x86"

DESCRIPTION="PHP Bindings for ZeroMQ messaging"
LICENSE="BSD"
SLOT="0"
IUSE="czmq"

RDEPEND="net-libs/zeromq czmq? ( <net-libs/czmq-3 )"
DEPEND="${RDEPEND} virtual/pkgconfig"

src_configure() {
	local PHP_EXT_ECONF_ARGS=( $(use_with czmq) )
	php-ext-source-r3_src_configure
}
