# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="object-reflector"

DESCRIPTION="Allows reflection of object attributes, including inherited and non-public ones"
HOMEPAGE="http://phpunit.de"
SRC_URI="https://github.com/sebastianbergmann/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

S="${WORKDIR}/${MY_PN}-${PV}"

RDEPEND="dev-php/fedora-autoloader
	=dev-lang/php-7*"

src_install() {
	insinto /usr/share/php/SebastianBergmann/ObjectReflector
	doins src/ObjectReflector.php src/{,InvalidArgument}Exception.php
	doins "${FILESDIR}/autoload.php"
}
