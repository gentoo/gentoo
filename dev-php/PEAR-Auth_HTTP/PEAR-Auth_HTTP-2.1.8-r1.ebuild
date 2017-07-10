# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit php-pear-r2

DESCRIPTION="Create HTTP authentication systems like Apache's realm-based .htaccess mechanism"
LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
RDEPEND="dev-php/PEAR-Auth"
DOCS=( docs/sample.sql )
HTML_DOCS=( docs/test_digest_simple.php docs/test_digest_post.php docs/test_digest_get.php docs/test_basic_simple.php )
