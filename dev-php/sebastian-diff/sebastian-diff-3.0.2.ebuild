# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="diff"

DESCRIPTION="PHP Diff implementation"
HOMEPAGE="https://phpunit.de"
SRC_URI="https://github.com/sebastianbergmann/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ~ia64 ppc ppc64 ~s390 sparc x86"
IUSE=""

S="${WORKDIR}/${MY_PN}-${PV}"

RDEPEND="dev-php/fedora-autoloader
	>=dev-lang/php-7.1:*"

src_install() {
	insinto /usr/share/php/SebastianBergmann/Diff
	doins -r src/*
	newins "${FILESDIR}/autoload-3.0.2.php" autoload.php
}
