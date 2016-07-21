# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
