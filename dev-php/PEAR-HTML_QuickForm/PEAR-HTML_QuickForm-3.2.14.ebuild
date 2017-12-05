# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

DESCRIPTION="Provides methods for creating, validating, processing HTML forms"
LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="examples"

RDEPEND=">=dev-php/PEAR-HTML_Common-1.2.1-r1"

src_install() {
	local HTML_DOCS
	insinto /usr/share/php/HTML
	doins -r QuickForm.php QuickForm
	php-pear-r2_install_packagexml
	if use examples; then
		HTML_DOCS=( docs/rules-custom.php docs/rules-builtin.php docs/groups.php
			docs/formrule.php docs/filters.php docs/elements.php docs/renderers )
	fi
	einstalldocs
}
