# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit versionator

MY_PV=$(delete_all_version_separators "${PV}" )
DESCRIPTION="Active Data Objects Data Base library for PHP"
HOMEPAGE="http://adodb.sourceforge.net/"
SRC_URI="mirror://sourceforge/adodb/adodb-php5-only/${PN}-${MY_PV}-for-php5/${PN}${MY_PV}a.tgz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND="dev-lang/php"

S="${WORKDIR}/${PN}"$(get_major_version)
DOCS="license.txt readme.txt xmlschema.dtd session/adodb-sess.txt pear/readme.Auth.txt docs/*htm"

pkg_setup() {
	ewarn "ADODB requires some form of SQL or ODBC support in your PHP."
}

src_install() {
	# install php and xsl files
	dodir "/usr/share/php/${PN}"
	find . \( -name '*.php' -o -name '*.xsl' \) -exec tar -c '{}' \+ \
		| tar -x -C "${D}/usr/share/php/${PN}"

	default_src_install # copy DOCS
}
