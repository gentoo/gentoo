# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

MY_PN="${PN/webmozart-//}"

DESCRIPTION="Assertions to validate method input/output with nice error messages"
HOMEPAGE="https://github.com/webmozart/assert"
SRC_URI="https://github.com/webmozart/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ppc ppc64 ~s390 sparc x86"
IUSE=""

S="${WORKDIR}/${MY_PN}-${PV}"

RDEPEND="dev-php/fedora-autoloader
	>=dev-lang/php-5.6:*[ctype]"

src_install() {
	insinto /usr/share/php/Webmozart/Assert
	doins -r src/*
	doins "${FILESDIR}/autoload.php"
}
