# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="manifest"

DESCRIPTION="Component for reading phar.io manifest information from a PHP Archive (PHAR)"
HOMEPAGE="https://github.com/phar-io/manifest"
SRC_URI="https://github.com/phar-io/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

S="${WORKDIR}/${MY_PN}-${PV}"

RDEPEND="dev-php/fedora-autoloader
	>=dev-php/phar-io-version-1.0.1
	>=dev-lang/php-5.6[phar]"

src_install() {
	insinto /usr/share/php/PharIo/Manifest
	doins -r src/*
	doins "${FILESDIR}/autoload.php"
	dodoc README.md
}
