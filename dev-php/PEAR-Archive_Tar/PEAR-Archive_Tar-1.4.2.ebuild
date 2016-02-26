# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

MY_PN="${PN/PEAR-/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Tar file management class"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""
SRC_URI="http://pear.php.net/get/${MY_P}.tgz"
DEPEND=">=dev-lang/php-5.4:*[pcre(+)]
		>=dev-php/PEAR-PEAR-1.9.0
"
RDEPEND=">=dev-lang/php-5.4:*[bzip2,posix,zlib]
	${DEPEND}"
PDEPEND="dev-php/pear"
HOMEPAGE="http://pear.php.net/package/Archive_Tar"

S="${WORKDIR}/${MY_P}"

src_install() {
	insinto /usr/share/php/Archive
	doins Archive/*

	dodoc docs/*
}
