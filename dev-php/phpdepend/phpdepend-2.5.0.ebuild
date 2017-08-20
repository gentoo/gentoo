# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN=pdepend

DESCRIPTION="Static code analysis for PHP"
HOMEPAGE="http://www.pdepend.org/"

# The test suite is absent from the release tarballs because
# the only build system that Composer understands is "cp -r".
# To obtain the tests, we would need to grab a VCS snapshot.
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/php
	dev-php/fedora-autoloader
	>=dev-php/symfony-config-2.3
	>=dev-php/symfony-dependency-injection-2.3
	>=dev-php/symfony-filesystem-2.3"

S="${WORKDIR}/${MY_PN}-${PV}"

src_install() {
	dodoc CHANGELOG

	# The executable will only look for autoload.php in one place, so we
	# create an (otherwise pointless) vendor directory to house it.
	insinto "/usr/share/${PN}/vendor"
	doins "${FILESDIR}/autoload.php"

	insinto "/usr/share/${PN}/src"
	doins -r src/main

	# The executable uses relative include paths, so the one users will
	# actually run needs to be symlinked into the source tree.
	exeinto "/usr/share/${PN}/src/bin"
	doexe "src/bin/${MY_PN}"
	dosym "/usr/share/${PN}/src/bin/${MY_PN}" "/usr/bin/${MY_PN}"
}
