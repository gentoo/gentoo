# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="JSON Lint for PHP"
HOMEPAGE="https://github.com/Seldaek/jsonlint"
SRC_URI="https://github.com/Seldaek/jsonlint/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="dev-php/fedora-autoloader
	dev-lang/php:*"

src_prepare() {
	default

	phpab \
		--output src/Seld/JsonLint/autoload.php \
		--template fedora2 \
		--basedir src/Seld/JsonLint \
		src \
		|| die
}

src_install() {
	insinto "/usr/share/php/Seld/JsonLint"
	doins -r src/Seld/JsonLint/.

	einstalldocs
}
