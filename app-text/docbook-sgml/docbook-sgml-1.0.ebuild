# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/docbook-sgml/docbook-sgml-1.0.ebuild,v 1.31 2010/07/10 19:25:27 armin76 Exp $

DESCRIPTION="A helper package for sgml docbook"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 sh sparc x86"
HOMEPAGE="http://www.docbook.org/sgml/"
IUSE=""

RDEPEND="app-text/sgml-common app-text/openjade
	>=app-text/docbook-dsssl-stylesheets-1.64
	>=app-text/docbook-sgml-utils-0.6.6
	~app-text/docbook-sgml-dtd-3.0
	~app-text/docbook-sgml-dtd-3.1
	~app-text/docbook-sgml-dtd-4.0
	~app-text/docbook-sgml-dtd-4.1"
