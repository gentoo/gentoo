# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Symfony ExpressionLanguage Component"
HOMEPAGE="https://github.com/symfony/expression-language"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-lang/php:*
	dev-php/fedora-autoloader
	>=dev-php/symfony-cache-3.1"
DEPEND="
	test? (
		${RDEPEND}
		dev-php/phpunit )"

S="${WORKDIR}/expression-language-${PV}"

src_prepare() {
	default
	if use test; then
		cp "${FILESDIR}"/autoload.php "${S}"/autoload-test.php || die
	fi
}

src_install() {
	insinto "/usr/share/php/Symfony/Component/ExpressionLanguage"
	# As there is no src dir we have to list needed dir + files
	doins -r Node/ ParserCache/ Resources/ Compiler.php ExpressionFunction.php \
	ExpressionFunctionProviderInterface.php ExpressionLanguage.php \
	Expression.php Lexer.php LICENSE ParsedExpression.php Parser.php \
	SerializedParsedExpression.php SyntaxError.php Token.php \
	TokenStream.php	"${FILESDIR}"/autoload.php
	dodoc README.md
}

src_test() {
	phpunit --bootstrap "${S}"/autoload-test.php || die "test suite failed"
}
