# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="Autoload"

DESCRIPTION="PHP Autoload Builder"
HOMEPAGE="https://github.com/theseer/Autoload"
SRC_URI="https://github.com/theseer/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ppc ppc64 ~s390 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

CDEPEND="dev-lang/php:*[cli,fileinfo(-),tokenizer(-)]
	>=dev-php/theseer-DirectoryScanner-1.3
	<dev-php/theseer-DirectoryScanner-2
	>=dev-php/zetacomponents-Base-1.8
	<dev-php/zetacomponents-Base-2
	>=dev-php/zetacomponents-ConsoleTools-1.7.1
	<dev-php/zetacomponents-ConsoleTools-2"

BDEPEND="${CDEPEND}
	test? (
		>=dev-php/phpunit-8
		<dev-php/phpunit-9
	)"

RDEPEND="${CDEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-1.26.0-autoload.php.patch )

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	default

	# Set version
	sed -i \
		-e "s/%development%/${PV}/" \
		phpab.php \
		composer/bin/phpab \
		|| die

	cp --target-directory src/templates/ci \
		"${FILESDIR}"/fedora.php.tpl \
		"${FILESDIR}"/fedora2.php.tpl \
		|| die

	# Mimick layout to bootstrap phpab
	mkdir --parents \
		vendor/theseer/directoryscanner \
		vendor/zetacomponents/base \
		vendor/zetacomponents/console-tools \
		|| die

	ln -s /usr/share/php/TheSeer/DirectoryScanner	vendor/theseer/directoryscanner/src || die
	ln -s /usr/share/php/ezc/Base			vendor/zetacomponents/base/src || die
	ln -s /usr/share/php/ezc/ConsoleTools		vendor/zetacomponents/console-tools/src  || die

	./phpab.php \
		--output src/autoload.php \
		--template "${FILESDIR}"/autoload.php.tpl \
		--basedir src \
		src || die
}

src_test() {
	phpunit --no-coverage --verbose || die "Unit testing failed!"
}

src_install() {
	insinto /usr/share/php/TheSeer/${MY_PN}
	doins -r src/*

	dobin "${S}"/composer/bin/phpab

	einstalldocs
}
