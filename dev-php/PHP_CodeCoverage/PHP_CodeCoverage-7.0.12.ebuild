# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="php-code-coverage"

USE_PHP="php7-2 php7-3 php7-4"

DESCRIPTION="Collection, processing, and rendering for PHP code coverage"
HOMEPAGE="https://phpunit.de"
SRC_URI="https://github.com/sebastianbergmann/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ppc ppc64 ~s390 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

CDEPEND="dev-php/fedora-autoloader
	>=dev-php/File_Iterator-2.0.2
	>=dev-php/Text_Template-1.2.1
	>=dev-php/PHP_TokenStream-3.1.1
	>=dev-php/sebastian-environment-4.2.2
	>=dev-php/sebastian-version-2.0.1
	>=dev-php/sebastian-code-unit-reverse-lookup-1.0.1
	>=dev-php/theseer-tokenizer-1.1.3
	>=dev-lang/php-7.2:*[xml(-),xmlwriter(-)]"

BDEPEND="dev-php/theseer-Autoload
	test? (
		${CDEPEND}
		dev-php/phpunit
	)"

RDEPEND="${CDEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	default

	phpab \
		--output src/autoload.php \
		--template fedora2 \
		--basedir src \
		src || die

	cat >> src/autoload.php <<EOF || die "failed to extend autoload.php"

// Dependencies
\Fedora\Autoloader\Dependencies::required([
	'/usr/share/php/File/Iterator/autoload.php',
	'/usr/share/php/PHP/Token/autoload.php',
	'/usr/share/php/SebastianBergmann/Version/autoload.php',
	'/usr/share/php/SebastianBergmann/Environment/autoload.php',
	'/usr/share/php/SebastianBergmann/CodeUnitReverseLookup/autoload.php',
	'/usr/share/php/Text/Template/autoload.php',
	'/usr/share/php/TheSeer/Tokenizer/autoload.php',
]);
EOF
}

src_install() {
	insinto /usr/share/php/PHP/CodeCoverage
	doins -r src/*
}

src_test() {
	mkdir vendor || die

	phpab \
		--output vendor/autoload.php \
		--template fedora2 \
		--exclude 'tests/_files/Crash.php' \
		--exclude 'tests/_files/source*.php' \
		src \
		tests \
		|| die

	cat >> vendor/autoload.php <<EOF || die "failed to extend autoload.php"

// Dependencies
\Fedora\Autoloader\Dependencies::required([
	'/usr/share/php/File/Iterator/autoload.php',
	'/usr/share/php/PHP/Token/autoload.php',
	'/usr/share/php/SebastianBergmann/Version/autoload.php',
	'/usr/share/php/SebastianBergmann/Environment/autoload.php',
	'/usr/share/php/SebastianBergmann/CodeUnitReverseLookup/autoload.php',
	'/usr/share/php/Text/Template/autoload.php',
	'/usr/share/php/TheSeer/Tokenizer/autoload.php',
]);
EOF

	local target
	for target in ${USE_PHP//-/.} ; do
		if [[ -x /usr/bin/${target} ]] ; then
			${target} /usr/bin/phpunit -c phpunit.xml --no-coverage --verbose || die "tests using ${target} failed"
		fi
	done
}

pkg_postinst() {
	ewarn "This library now loads via /usr/share/php/PHP/CodeCoverage/autoload.php"
	ewarn "Please update any scripts to require the autoloader"
}
