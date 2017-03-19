# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

DESCRIPTION="Generation of CAPTCHAs"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="minimal"

RDEPEND="dev-php/PEAR-PEAR >=dev-lang/php-5.3:*[gd,truetype] >=dev-php/PEAR-Text_Password-1.1.1
	!minimal? ( dev-php/PEAR-Numbers_Words
		dev-php/PEAR-Text_Figlet
		>=dev-php/PEAR-Image_Text-0.7.0 )"

src_prepare() {
	sed -i -e '/role="doc"/d' -e '/role="test"/d' "${WORKDIR}/package.xml" || die
	eapply_user
}

src_install() {
	local DOCS=( README )
	php-pear-r2_src_install
}
