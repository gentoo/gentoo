# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-frameworks/kdoctools/kdoctools-5.10.0.ebuild,v 1.1 2015/05/09 10:36:06 mrueg Exp $

EAPI=5

inherit kde5

DESCRIPTION="Framework providing tools to generate documentation in various formats from DocBook files"
LICENSE="MIT"
KEYWORDS=" ~amd64 ~x86"
IUSE=""

RDEPEND="
	$(add_frameworks_dep karchive)
	app-text/docbook-xml-dtd:4.5
	app-text/docbook-xsl-stylesheets
	dev-libs/libxml2:2
	dev-libs/libxslt
"
DEPEND="${RDEPEND}
	dev-lang/perl
	dev-perl/URI
"
