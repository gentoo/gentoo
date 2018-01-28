# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Convert tokenized PHP source code into XML and other formats"
HOMEPAGE="https://github.com/theseer/tokenizer"
SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="test"

S="${WORKDIR}/tokenizer-${PV}"

RDEPEND="dev-php/fedora-autoloader
	>=dev-lang/php-7.0:*[tokenizer,xmlwriter]"

DEPEND="test? ( ${RDEPEND} dev-php/phpunit )"

src_prepare() {
	cp "${FILESDIR}/autoload.php" src/ || die
	default
}

src_install() {
	insinto /usr/share/php/TheSeer/Tokenizer
	doins src/*.php
	dodoc README.md
}

src_test() {
	phpunit || die "Unit testing failed!"
}
