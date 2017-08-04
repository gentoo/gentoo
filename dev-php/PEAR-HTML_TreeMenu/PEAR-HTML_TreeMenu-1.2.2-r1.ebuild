# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

DESCRIPTION="Provides an API to create a HTML tree"
LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE=""

PATCHES=( "${FILESDIR}/modern-syntax.patch" )

src_install() {
	php-pear-r2_src_install
	docinto html
	dodoc -r TreeMenu.js images imagesAlt imagesAlt2 imagesAlt3 docs/example.php
}

pkg_postinst() {
	elog "Please copy the TreeMenu.js and the contents of one of the images"
	elog "directory from ${EROOT}usr/share/doc/${PF}/html to the same location"
	elog "in your website for this script to work properly"
}
