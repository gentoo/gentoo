# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Sphinx-Search/Sphinx-Search-0.280-r1.ebuild,v 1.1 2013/09/14 13:39:57 idella4 Exp $

EAPI=5

MODULE_AUTHOR=JJSCHUTZ
MODULE_VERSION=0.28
inherit perl-module

DESCRIPTION="Perl API client for Sphinx search engine"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="test"

RDEPEND="dev-perl/File-SearchPath
	dev-perl/Path-Class
	dev-perl/DBI"
DEPEND="test? ( ${RDEPEND} )"
SRC_TEST="do parallel"

pkg_postinst() {
	ewarn "You must connect to a Sphinx searchd of 0.9.8_rc1 or newer"
}
