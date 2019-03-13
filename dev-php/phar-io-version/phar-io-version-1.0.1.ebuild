# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Library for handling version information and constraints"
HOMEPAGE="https://github.com/phar-io/version"
SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

S="${WORKDIR}/version-${PV}"

RDEPEND="dev-php/fedora-autoloader
	dev-lang/php:*"

src_install() {
	insinto /usr/share/php/PharIo/Version
	doins src/*.php
	doins "${FILESDIR}/autoload.php"
	dodoc README.md
}
