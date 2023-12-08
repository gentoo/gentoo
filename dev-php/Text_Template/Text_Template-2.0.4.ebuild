# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="php-text-template"

DESCRIPTION="A simple template engine"
HOMEPAGE="https://phpunit.de"
SRC_URI="https://github.com/sebastianbergmann/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ~ia64 ppc ppc64 ~s390 sparc x86"
IUSE=""

S="${WORKDIR}/${MY_PN}-${PV}"

RDEPEND="dev-php/fedora-autoloader
	>=dev-lang/php-7.3:*"

src_install() {
	insinto /usr/share/php/Text/Template
	doins -r src/*
	newins "${FILESDIR}/autoload-2.0.4.php" autoload.php
}

pkg_postinst() {
	ewarn "This library now loads via /usr/share/php/Text/Template/autoload.php"
	ewarn "Please update any scripts to require the autoloader"
}
