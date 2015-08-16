# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"

DESCRIPTION="PEAR - PHP Extension and Application Repository"
HOMEPAGE="http://pear.php.net/"
SRC_URI=""
LICENSE="MIT"
SLOT="0"
IUSE=""
S="${WORKDIR}"

DEPEND=">=dev-lang/php-5.4:*
	!<dev-php/PEAR-PEAR-1.8.1
	~dev-php/PEAR-PEAR-${PV}
	>=dev-php/PEAR-Archive_Tar-1.4.0
	>=dev-php/PEAR-Console_Getopt-1.4.1
	>=dev-php/PEAR-Structures_Graph-1.1.0
	>=dev-php/PEAR-XML_Util-1.3.0"
RDEPEND="${DEPEND}"

src_install() {
	:;
}

pkg_postinst() {
	pear clear-cache

	# Update PEAR/PECL channels as needed, add new ones to the list if needed
	elog "Updating PEAR/PECL channels"
	local pearchans="pear.php.net pecl.php.net components.ez.no
	pear.propelorm.org pear.phing.info	pear.symfony-project.com
	pear.phpontrax.com pear.agavi.org"

	for chan in ${pearchans} ; do
		pear channel-discover ${chan}
		pear channel-update ${chan}
	done
}
