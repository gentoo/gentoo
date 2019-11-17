# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PHP_EXT_NAME="xdebug"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="yes"
PHP_EXT_INIFILE="2.6.0-xdebug.ini"

USE_PHP="php7-1 php7-2 php7-3 php7-4"

MY_PV="${PV/_/}"
MY_PV="${MY_PV/rc/RC}"

S="${WORKDIR}/${PN}-${MY_PV}"

inherit php-ext-source-r3

KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"

DESCRIPTION="A PHP debugging and profiling extension"
HOMEPAGE="https://xdebug.org/"
# Using tarball from GitHub for tests
#SRC_URI="https://pecl.php.net/get/${PN}-${MY_PV}.tgz"
SRC_URI="https://github.com/xdebug/xdebug/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Xdebug"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
		~dev-php/xdebug-client-${PV}"
DOCS=( README.rst CREDITS )
PHP_EXT_ECONF_ARGS=()

pkg_postinst() {
	ewarn "We have set xdebug.default_enable to 0 (off), as xdebug can be"
	ewarn "installed as a dependency, and not all users will want xdebug to be"
	ewarn "enabled by default. If you want to enable it, you should edit the"
	ewarn "ini file and set xdebug.default_enable to 1. Alternatively you can"
	ewarn "call xdebug_enable() in your code."
}
