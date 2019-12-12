# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

KEYWORDS="~amd64 ~x86"

DESCRIPTION="SabreAMF is a Flash Remoting server and client for PHP"
HOMEPAGE="https://github.com/evert/SabreAMF"
SRC_URI="https://github.com/evert/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
IUSE="examples"

RDEPEND="dev-php/fedora-autoloader"

DOCS=( README.md ChangeLog )

src_install() {
	insinto /usr/share/php/${PN}
	doins -r lib/${PN}/* "${FILESDIR}/autoload.php"
	einstalldocs
	if use examples ; then
		docinto examples
		docompress -x /usr/share/doc/${P}/examples
		dodoc examples/*
	fi
}
