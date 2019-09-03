# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A helper package for sgml docbook"
HOMEPAGE="https://www.docbook.org/sgml/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86"

RDEPEND="
	>=app-text/docbook-dsssl-stylesheets-1.64
	~app-text/docbook-sgml-dtd-3.0
	~app-text/docbook-sgml-dtd-3.1
	~app-text/docbook-sgml-dtd-4.0
	~app-text/docbook-sgml-dtd-4.1
	>=app-text/docbook-sgml-utils-0.6.6
	app-text/openjade
	app-text/sgml-common"
