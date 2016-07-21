# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_P="${PN}1-${PV}"
DESCRIPTION="An object relational mapper for PHP5"
HOMEPAGE="http://www.doctrine-project.org/"
SRC_URI="https://github.com/${PN}/${PN}1/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1 MIT BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/php-5.2.3:*[cli,pdo]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_install() {
	insinto /usr/share/php
	doins -r lib/Doctrine
	doins lib/Doctrine.php
}
