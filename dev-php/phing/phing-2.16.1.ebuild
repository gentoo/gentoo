# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="PHP project build system based on Apache Ant"
HOMEPAGE="http://www.phing.info/"
SRC_URI="http://www.phing.info/get/${P}.tgz"

LICENSE="FDL-1.3 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples minimal zip"

RDEPEND="dev-lang/php:*[cli,xml,xslt,zip?]
	dev-php/symfony-yaml
	!minimal? (
		dev-php/PEAR-HTTP_Request2
		dev-php/PEAR-PEAR_PackageFileManager
		dev-php/PEAR-VersionControl_SVN
		dev-php/PHP_CodeCoverage
		dev-php/phpDocumentor
		dev-php/phpmd
		dev-php/phpunit
		dev-php/simpletest
		dev-php/xdebug
	)"

S="${WORKDIR}"

src_install() {
	dodoc CHANGELOG.md CREDITS.md README.md
	dodoc -r docs/docbook5/en/output/hlhtml
	use doc && dodoc -r docs/api
	use examples && dodoc -r docs/example

	# Install the executable (and the PHP file it wraps) outside of the
	# PHP include directory, since nobody should be including it.
	exeinto "/usr/share/${PN}/bin"
	doexe "bin/${PN}"
	insinto "/usr/share/${PN}/bin"
	doins "bin/${PN}.php"
	dosym "../share/${PN}/bin/${PN}" "/usr/bin/${PN}"

	# Phing tries to get the version number from this file.
	insinto "/usr/share/${PN}/etc"
	doins etc/VERSION.TXT

	# The executable will only look for autoload.php in one place, so we
	# create an (otherwise pointless) vendor directory to house it.
	insinto "/usr/share/${PN}/vendor"
	doins "${FILESDIR}/autoload.php"

	# But install the library under /usr/share/php.
	insinto "/usr/share/php"
	doins -r "classes/${PN}"
}
