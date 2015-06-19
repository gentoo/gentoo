# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/smarty-docs/smarty-docs-2.6.14.ebuild,v 1.11 2014/08/10 21:05:45 slyfox Exp $

KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"

MY_P="Smarty-${PV}-docs"

DESCRIPTION="Documentation for Smarty, a template engine for PHP"
HOMEPAGE="http://smarty.php.net/docs.php"
SRC_URI="http://smarty.php.net/distributions/manual/en/${MY_P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/manual"

src_install() {
	dohtml -r .
}
