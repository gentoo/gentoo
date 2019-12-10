# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2 vcs-snapshot

DESCRIPTION="Simple OO wrapper interface for the Subversion command-line client"
SRC_URI="https://github.com/pear/VersionControl_SVN/archive/6c9580df92f0cc77a6eb6fcc216c56913bf308e7.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"
RDEPEND=""
DEPEND="test? ( dev-vcs/subversion dev-php/phpunit )"
S="${WORKDIR}/PEAR-${PHP_PEAR_PKG_NAME}-${PV}"

src_prepare() {
	einfo "Patching SVN.php and SVN/Command.php to use proper paths by default"
	sed -i -e 's:/usr/local:/usr:g' VersionControl/SVN.php || die "sed failed"
	sed -i -e 's:/usr/local:/usr:g' VersionControl/SVN/Command.php || die "sed failed"
	sed -i 's/ +%d / %i /' tests/resetxml_19910.phpt || die
	default
}

src_test() {
	phpunit tests || die "Tests failed"
}
