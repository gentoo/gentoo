# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="Reading phar.io manifest information from a PHP Archive (PHAR)"
HOMEPAGE="https://github.com/phar-io/manifest"
SRC_URI="https://github.com/phar-io/manifest/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="examples"

S="${WORKDIR}/manifest-${PV}"

RDEPEND="dev-php/fedora-autoloader
	>=dev-php/phar-io-version-2
	dev-lang/php:*[phar]"

src_install() {
	insinto /usr/share/php/PharIo/Manifest
	doins -r src/*
	doins "${FILESDIR}/autoload.php"
	dodoc README.md
	use examples && dodoc -r examples
}
