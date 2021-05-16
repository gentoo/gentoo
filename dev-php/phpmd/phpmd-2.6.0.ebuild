# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="PHP mess detector"
HOMEPAGE="http://www.phpmd.org/"

# The test suite is absent from the release tarballs because
# the only build system that Composer understands is "cp -r".
# To obtain the tests, we would need to grab a VCS snapshot.
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/php[xml]
	dev-php/phpdepend"

src_install() {
	dodoc AUTHORS.rst CHANGELOG CONTRIBUTING.md README.rst

	# The executable will only look for autoload.php in one place, so we
	# create an (otherwise pointless) vendor directory to house it.
	insinto "/usr/share/${PN}/vendor"
	doins "${FILESDIR}/autoload.php"

	insinto "/usr/share/${PN}/src"
	doins -r src/main

	# The executable uses relative include paths, so the one users will
	# actually run needs to be symlinked into the source tree.
	exeinto "/usr/share/${PN}/src/bin"
	doexe "src/bin/${PN}"
	dosym "../share/${PN}/src/bin/${PN}" "/usr/bin/${PN}"
}
