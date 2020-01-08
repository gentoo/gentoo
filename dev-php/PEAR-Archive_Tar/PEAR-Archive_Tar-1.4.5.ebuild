# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN/PEAR-/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Tar file management class"
HOMEPAGE="https://pear.php.net/package/Archive_Tar"
SRC_URI="https://pear.php.net/get/${MY_P}.tgz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ia64 ppc ppc64 ~s390 ~sh sparc x86"
IUSE=""

# bzip2 and zlib are needed for compressed tarballs, and there's one
# call to preg_match to test paths against a pattern of files and
# directories that will be ignored.
RDEPEND="dev-lang/php:*[bzip2,pcre(+),zlib]"
PDEPEND="dev-php/PEAR-PEAR"
DEPEND=""

S="${WORKDIR}/${MY_P}"

src_install() {
	insinto /usr/share/php
	doins -r Archive

	dodoc docs/*
}
