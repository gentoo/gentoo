# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="${PN/sebastian-//}"

DESCRIPTION="Recursively process PHP variables"
HOMEPAGE="http://phpunit.de"
SRC_URI="https://github.com/sebastianbergmann/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86"
IUSE=""

S="${WORKDIR}/${MY_PN}-${PV}"

RDEPEND="dev-php/fedora-autoloader
	>=dev-lang/php-5.6:*"

src_install() {
	insinto /usr/share/php/SebastianBergmann/RecursionContext
	doins -r src/*
	doins "${FILESDIR}/autoload.php"
}
