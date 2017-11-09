# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

DESCRIPTION="Element for HTML_QuickForm that emulate a multi-select"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples"
RDEPEND=">=dev-php/PEAR-HTML_QuickForm-3.2.10
	>=dev-php/PEAR-HTML_Common-1.2.5"

src_install() {
	local HTML_DOCS=( qfamsHandler.js qfamsHandler-min.js )
	use examples && HTML_DOCS+=( examples )
	insinto /usr/share/php/HTML/QuickForm
	doins advmultiselect.php
	php-pear-r2_install_packagexml
	einstalldocs
}
