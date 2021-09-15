# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

USE_PHP="php7-3 php7-4 php8-0"
inherit php-ext-pecl-r3

if [[ ${PV} == "9999" ]]; then
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/mkoppanen/php-zmq.git"
	EGIT_CHECKOUT_DIR="${PHP_EXT_S}"

	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="PHP Bindings for ZeroMQ messaging"
LICENSE="BSD"
SLOT="0"
IUSE=""

BDEPEND="virtual/pkgconfig"
DEPEND="net-libs/zeromq"
RDEPEND="net-libs/zeromq:="
