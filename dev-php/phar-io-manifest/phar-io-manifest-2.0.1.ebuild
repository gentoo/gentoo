# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="Reading phar.io manifest information from a PHP Archive (PHAR)"
HOMEPAGE="https://github.com/phar-io/manifest"
SRC_URI="https://github.com/phar-io/manifest/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="examples"

CDEPEND="dev-php/fedora-autoloader
	>=dev-php/phar-io-version-3.0.1
	>=dev-lang/php-7.2:*[phar,xml(-),xmlwriter(-)]"

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="${CDEPEND}"

S="${WORKDIR}/manifest-${PV}"

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
	'/usr/share/php/PharIo/Version/autoload.php'
]);
EOF
}

src_install() {
	insinto /usr/share/php/PharIo/Manifest
	doins -r src/*
	dodoc README.md
	use examples && dodoc -r examples
}
