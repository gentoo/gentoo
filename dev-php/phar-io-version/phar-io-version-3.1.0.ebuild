# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="Library for handling version information and constraints"
HOMEPAGE="https://github.com/phar-io/version"
SRC_URI="https://github.com/phar-io/version/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ppc ppc64 ~s390 sparc x86"
IUSE=""

S="${WORKDIR}/version-${PV}"

CDEPEND="dev-php/fedora-autoloader
	>=dev-lang/php-7.2:*"

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="${CDEPEND}"

src_prepare() {
	default

	phpab \
		--output src/autoload.php \
		--template fedora2 \
		--basedir src \
		src \
		|| die
}

src_install() {
	insinto /usr/share/php/PharIo/Version
	doins src/*.php
	dodoc README.md
}
