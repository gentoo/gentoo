# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="php-token-stream"

DESCRIPTION="Wrapper around PHP's tokenizer extension"
HOMEPAGE="http://phpunit.de"
SRC_URI="https://github.com/sebastianbergmann/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86"
IUSE=""

S="${WORKDIR}/${MY_PN}-${PV}"

RDEPEND="dev-php/fedora-autoloader
	|| (
		dev-lang/php:5.6[tokenizer]
		dev-lang/php:7.0[tokenizer]
		dev-lang/php:7.1[tokenizer]
	)"

src_install() {
	insinto /usr/share/php/PHP/Token
	doins -r src/*
	doins "${FILESDIR}/autoload.php"
}

pkg_postinst() {
	ewarn "This library now loads via /usr/share/php/PHP/Token/autoload.php"
	ewarn "Please update any scripts to require the autoloader"
}
