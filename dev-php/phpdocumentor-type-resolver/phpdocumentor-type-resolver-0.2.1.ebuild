# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="TypeResolver"
MY_VENDOR="phpDocumentor"

DESCRIPTION="PSR-5 based resolver of Class names, Types and Structural Element Names"
HOMEPAGE="https://www.phpdoc.org"
SRC_URI="https://github.com/${MY_VENDOR}/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ia64 ppc ppc64 ~s390 ~sh sparc x86"
IUSE=""

S="${WORKDIR}/${MY_PN}-${PV}"

RDEPEND="dev-php/fedora-autoloader
	<dev-php/phpdocumentor-reflection-common-2
	>=dev-lang/php-5.6:*"

src_install() {
	insinto /usr/share/php/${MY_VENDOR}/${MY_PN}
	doins -r src/*
	doins "${FILESDIR}/autoload.php"
}
