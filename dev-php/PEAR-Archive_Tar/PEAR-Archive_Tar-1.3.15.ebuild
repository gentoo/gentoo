# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-Archive_Tar/PEAR-Archive_Tar-1.3.15.ebuild,v 1.5 2015/04/29 09:08:15 ago Exp $

EAPI="5"

MY_PN="${PN/PEAR-/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Tar file management class"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~s390 ~sh sparc x86"
IUSE=""
SRC_URI="http://pear.php.net/get/${MY_P}.tgz"
DEPEND="dev-lang/php:*[pcre(+)]
		>=dev-php/PEAR-PEAR-1.8.1
"
RDEPEND="dev-lang/php:*[bzip2,posix,zlib]
	${DEPEND}"
PDEPEND="dev-php/pear"
HOMEPAGE="http://pear.php.net/package/Archive_Tar"

S="${WORKDIR}/${MY_P}"

src_install() {
	insinto /usr/share/php/Archive
	doins Archive/*

	dodoc docs/*
}
