# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Symfony DependencyInjection Component"
HOMEPAGE="https://github.com/symfony/dependency-injection"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-lang/php:*
	dev-php/fedora-autoloader"
DEPEND="
	test? (
		${RDEPEND}
		dev-php/phpunit
		>=dev-php/symfony-yaml-3.2
		>=dev-php/symfony-config-3.0
		>=dev-php/symfony-expression-language-3.0 )"

S="${WORKDIR}/dependency-injection-${PV}"

src_prepare() {
	default
	if use test; then
		cp "${FILESDIR}"/autoload.php "${S}"/autoload-test.php || die
		echo "
\$vendorDir = '/usr/share/php';
// Dependencies
\Fedora\Autoloader\Dependencies::required(array(
	\$vendorDir . '/Symfony/Component/Yaml/autoload.php',
	\$vendorDir . '/Symfony/Component/Config/autoload.php',
	\$vendorDir . '/Symfony/Component/ExpressionLanguage/autoload.php',
));" >> "${S}"/autoload-test.php || die
	fi
}

src_install() {
	insinto "/usr/share/php/Symfony/Component/DependencyInjection"
	doins -r Compiler Dumper Exception Extension LazyProxy \
	Loader ParameterBag Alias.php ContainerAwareInterface.php \
	ContainerAware.php ContainerAwareTrait.php ContainerBuilder.php \
	ContainerInterface.php Container.php DefinitionDecorator.php \
	Definition.php ExpressionLanguage.php ExpressionLanguageProvider.php \
	IntrospectableContainerInterface.php LICENSE Parameter.php \
	Reference.php ResettableContainerInterface.php ScopeInterface.php \
	Scope.php SimpleXMLElement.php TaggedContainerInterface.php \
	Variable.php "${FILESDIR}"/autoload.php
	dodoc README.md
}

src_test() {
	phpunit --bootstrap "${S}"/autoload-test.php || die "test suite failed"
}
