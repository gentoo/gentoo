# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/mockery/mockery-0.9.0.ebuild,v 1.1 2015/05/06 02:59:43 grknight Exp $

EAPI=5
PHP_PEAR_CHANNEL="${FILESDIR}/channel.xml"
PHP_PEAR_PN="Mockery"
PHP_PEAR_URI="pear.survivethedeepend.com"
inherit php-pear-lib-r1

DESCRIPTION="Simple yet flexible PHP mock object framework for use in unit testing"
HOMEPAGE="https://github.com/padraic/mockery"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""
