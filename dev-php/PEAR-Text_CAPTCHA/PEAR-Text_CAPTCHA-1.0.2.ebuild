# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="${PN/PEAR-/}"
MY_P="${MY_PN}-${PV}"

HOMEPAGE="http://pear.php.net/package/${MY_PN}"
SRC_URI="http://pear.php.net/get/${MY_P}.tgz"
DESCRIPTION="Generation of CAPTCHAs"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="minimal"

RDEPEND="dev-php/PEAR-PEAR >=dev-lang/php-5.3:*[gd,truetype] >=dev-php/PEAR-Text_Password-1.1.1
	!minimal? ( dev-php/PEAR-Numbers_Words
		dev-php/PEAR-Text_Figlet
		>=dev-php/PEAR-Image_Text-0.7.0 )"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default_src_prepare
	sed -i -e '/role="doc"/d' -e '/role="test"/d' "${WORKDIR}/package.xml" || die
}

src_install() {
	local DOCS=( README )
	insinto /usr/share/php
	doins -r Text
	einstalldocs
}

pkg_postinst() {
	# Register the package from the package.xml file
	# Operation is not critical so die is not required
	if [[ -f "${WORKDIR}/package.xml" ]] ; then
		"${EROOT}usr/bin/peardev" install -nrO --force "${WORKDIR}/package.xml" 2> /dev/null
	fi
}

pkg_postrm() {
	# Uninstall known dependency
	"${EROOT}usr/bin/peardev" uninstall -nrO "pear.php.net/${MY_PN}"
}
