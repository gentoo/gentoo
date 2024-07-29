# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="orm-${PV}"
DESCRIPTION="An object relational mapper for PHP"
HOMEPAGE="https://www.doctrine-project.org/"
SRC_URI="https://github.com/${PN}/orm/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-lang/php-7.1:*[cli,pdo]"
DEPEND=""

S="${WORKDIR}/${MY_P}"

src_install() {
	insinto /usr/share/php
	doins -r lib/Doctrine
	insinto /usr/share/php/Doctrine
	exeinto /usr/share/php/Doctrine
	doins bin/doctrine.php
	doexe bin/doctrine
	dosym ../share/php/Doctrine/doctrine /usr/bin/doctrine
}
