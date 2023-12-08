# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Convert tokenized PHP source code into XML and other formats"
HOMEPAGE="https://github.com/theseer/tokenizer"
SRC_URI="https://github.com/theseer/tokenizer/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ~ia64 ppc ppc64 ~s390 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

CDEPEND="dev-lang/php:*
	dev-php/fedora-autoloader"

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="${CDEPEND}"

S="${WORKDIR}/tokenizer-${PV}"

src_prepare() {
	default

	phpab \
		--output src/autoload.php \
		--template fedora2 \
		--basedir src \
		src || die
}

src_install() {
	insinto /usr/share/php/TheSeer/Tokenizer
	doins -r src/*

	einstalldocs
}
