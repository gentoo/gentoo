# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="promise"

DESCRIPTION="A lightweight implementation of CommonJS Promises/A for PHP"
HOMEPAGE="https://reactphp.org/promise/"
SRC_URI="https://github.com/reactphp/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="dev-php/fedora-autoloader
	>=dev-lang/php-7.2:*"

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	default

	phpab \
		--output src/autoload.php \
		--template fedora2 \
		--basedir src \
		src \
		|| die

cat >> src/autoload.php <<EOF || die "failed to extend autoload.php"

// Dependencies
\Fedora\Autoloader\Dependencies::required([
	'/usr/share/php/React/Promise/functions.php'
]);
EOF
}

src_install() {
	insinto /usr/share/php/React/Promise
	doins -r src/*

	einstalldocs
}
