# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN/sebastian-//}"

DESCRIPTION="Traverses array structures and object graphs to enumerate all referenced objects"
HOMEPAGE="http://phpunit.de"
SRC_URI="https://github.com/sebastianbergmann/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

S="${WORKDIR}/${MY_PN}-${PV}"

RDEPEND="dev-php/fedora-autoloader
	<dev-php/sebastian-object-reflector-2.0
	>=dev-php/sebastian-recursion-context-3.0
	<dev-php/sebastian-recursion-context-4.0
	=dev-lang/php-7*:*"

src_install() {
	insinto /usr/share/php/SebastianBergmann/ObjectEnumerator
	doins -r src/*
	newins "${FILESDIR}/autoload-3.0.3.php" autoload.php
}
