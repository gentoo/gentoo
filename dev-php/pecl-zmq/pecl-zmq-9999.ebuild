# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

USE_PHP="php5-6 php7-0 php7-1 php7-2 php7-3 php7-4"

inherit php-ext-pecl-r3 git-r3

KEYWORDS=""

DESCRIPTION="PHP Bindings for ZeroMQ messaging"
LICENSE="BSD"
SLOT="0"
IUSE="czmq"

RDEPEND="net-libs/zeromq czmq? ( <net-libs/czmq-3 )"
DEPEND="${RDEPEND} virtual/pkgconfig"
SRC_URI=""
EGIT_REPO_URI="https://github.com/mkoppanen/php-zmq.git"
EGIT_CHECKOUT_DIR="${PHP_EXT_S}"

src_configure() {
	local PHP_EXT_ECONF_ARGS=( $(use_with czmq) )
	php-ext-source-r3_src_configure
}
