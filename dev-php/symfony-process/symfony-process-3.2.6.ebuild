# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Symfony Process Component"
HOMEPAGE="https://github.com/symfony/process"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="test"

RDEPEND="
	dev-lang/php:*
	dev-php/fedora-autoloader"
DEPEND="
	test? (
		${RDEPEND}
		dev-php/phpunit )"

S="${WORKDIR}/process-${PV}"

src_prepare() {
	default
	if use test; then
		cp "${FILESDIR}"/autoload.php "${S}"/autoload-test.php || die
	fi
}

src_install() {
	insinto "/usr/share/php/Symfony/Component/Process"
	doins -r Exception/ Pipes/ ExecutableFinder.php InputStream.php \
	LICENSE PhpExecutableFinder.php PhpProcess.php ProcessBuilder.php \
	Process.php ProcessUtils.php "${FILESDIR}"/autoload.php
	dodoc README.md
}

src_test() {
	phpunit --bootstrap "${S}"/autoload-test.php || die "test suite failed"
}
