# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_P="${PN}2-${PV}"
DESCRIPTION="An object relational mapper for PHP5"
HOMEPAGE="https://www.doctrine-project.org/"
SRC_URI="https://github.com/${PN}/${PN}2/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1 MIT BSD"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/php-5.3.2:*[cli,pdo]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_install() {
	insinto /usr/share/php
	doins -r lib/Doctrine
}
