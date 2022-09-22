# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PHP_PEAR_CHANNEL="${FILESDIR}/channel.xml"
PHP_PEAR_PKG_NAME="Mockery"
PHP_PEAR_DOMAIN="pear.survivethedeepend.com"
inherit php-pear-r2

DESCRIPTION="Simple yet flexible PHP mock object framework for use in unit testing"
HOMEPAGE="https://github.com/padraic/mockery"
SRC_URI="http://${PHP_PEAR_DOMAIN}/get/${PEAR_P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""
