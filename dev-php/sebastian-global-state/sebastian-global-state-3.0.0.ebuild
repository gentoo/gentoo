# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN/sebastian-//}"

DESCRIPTION="Snapshotting of global state"
HOMEPAGE="http://phpunit.de"
SRC_URI="https://github.com/sebastianbergmann/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

S="${WORKDIR}/${MY_PN}-${PV}"

RDEPEND="dev-php/fedora-autoloader
	>=dev-lang/php-7.2:*
	>=dev-php/sebastian-object-reflector-1.1.1
	<dev-php/sebastian-object-reflector-2.0
	=dev-php/sebastian-recursion-context-3*
"

src_install() {
	insinto /usr/share/php/SebastianBergmann/GlobalState
	doins -r src/*
	newins "${FILESDIR}/autoload-3.0.0.php" autoload.php
}
