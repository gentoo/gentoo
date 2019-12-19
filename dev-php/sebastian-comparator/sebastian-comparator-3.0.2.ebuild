# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN/sebastian-//}"

DESCRIPTION="Compare PHP values for equality"
HOMEPAGE="http://phpunit.de"
SRC_URI="https://github.com/sebastianbergmann/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

S="${WORKDIR}/${MY_PN}-${PV}"

RDEPEND="dev-php/fedora-autoloader
	>=dev-php/sebastian-diff-3.0
	<dev-php/sebastian-diff-4.0
	>=dev-php/sebastian-exporter-3.1
	<dev-php/sebastian-exporter-4.0
	>=dev-lang/php-7.1:*
"
src_install() {
	insinto /usr/share/php/SebastianBergmann/Comparator
	doins -r src/*
	doins "${FILESDIR}/autoload.php"
}
