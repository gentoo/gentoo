# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="${PN/PEAR-/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Render text using FIGlet fonts"
HOMEPAGE="https://pear.php.net/package/Text_Figlet"
SRC_URI="http://download.pear.php.net/package/${MY_P}.tgz"
LICENSE="PHP-3.01
	examples? ( GPL-2+ OFL-1.1 )"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples"

RDEPEND="dev-lang/php:*
	dev-php/PEAR-PEAR"

S="${WORKDIR}/${MY_P}"

src_install() {
	dodoc docs/README.TXT

	if use examples; then
		dodoc -r docs/examples

		# Earlier versions of this ebuild installed this font under
		# /usr/share/php/data, which is obviously the wrong place for
		# them, but is where we have configured PEAR's data_dir. The
		# fonts can be referenced by absolute path, however, and not
		# just by name. Since this font is used in the example -- and as
		# long as no one expects this *particular* font to work out of
		# the box -- installing it with the docs will suffice.
		#
		# The one consumer of this in the tree is PEAR-Text_CAPTCHA, and
		# it loads its fonts using an absolute path.
		dodoc fonts/makisupa.flf
	fi

	insinto /usr/share/php
	doins -r Text
}
