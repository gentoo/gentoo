# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2 vcs-snapshot

DESCRIPTION="Provides multiple methods for configuration manipulation"
LICENSE="PHP-2.02"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="xml"
RDEPEND="xml? ( dev-php/PEAR-XML_Parser dev-php/PEAR-XML_Util )"
SRC_URI="https://github.com/pear/Config/archive/606a24034ad80f9d6ccb5a8b698b702b392e4674.tar.gz -> ${PEAR_P}.tar.gz"
DOCS=( docs/TODO )
HTML_DOCS=( docs/Apache.php docs/IniCommented.php docs/IniFromScratch.php )

src_prepare() {
	# Move snapshot location to where the eclass expects
	mv "${S}/package.xml" "${WORKDIR}/package.xml" || die
	eapply_user
}
