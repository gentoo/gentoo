# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="PHP-Parser"

DESCRIPTION="PHP 5.2 to PHP 8.0 parser written in PHP"
HOMEPAGE="https://github.com/nikic/PHP-Parser"
SRC_URI="https://github.com/nikic/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE=""

S="${WORKDIR}/${MY_PN}-${PV}"

RDEPEND="dev-php/fedora-autoloader
	>=dev-lang/php-7.1:*[tokenizer(-)]"

src_install() {
	insinto /usr/share/php/nikic
	doins -r lib/*
	insinto /usr/share/php/nikic/PhpParser/
	doins "${FILESDIR}/autoload.php"
}
