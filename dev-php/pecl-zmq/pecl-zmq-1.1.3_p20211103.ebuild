# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

USE_PHP="php8-1"
inherit php-ext-pecl-r3

if [[ ${PV} == "9999" ]]; then
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/mkoppanen/php-zmq.git"
	EGIT_CHECKOUT_DIR="${PHP_EXT_S}"

	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
fi

SNAPSHOT="ee5fbc693f07b2d6f0d9fd748f131be82310f386"
SRC_URI="https://github.com/zeromq/php-zmq/archive/${SNAPSHOT}.tar.gz -> ${P}.tar.gz"

DESCRIPTION="PHP Bindings for ZeroMQ messaging"
LICENSE="BSD"
SLOT="0"
IUSE=""

BDEPEND="virtual/pkgconfig"
DEPEND="net-libs/zeromq"
RDEPEND="net-libs/zeromq:="

S="${WORKDIR}/php-zmq-${SNAPSHOT}"
PHP_EXT_S="${S}"
