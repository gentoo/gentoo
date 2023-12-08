# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

DESCRIPTION="Autofill a table with data"

LICENSE="PHP-3"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ia64 ppc ppc64 ~sparc x86"
IUSE=""
RDEPEND=">=dev-php/PEAR-HTML_Table-1.5-r1
	>=dev-php/PEAR-Numbers_Words-0.13.1-r1"

HTML_DOCS=( examples/HTML_Table_Matrix_example.php )
