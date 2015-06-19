# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/java-virtuals/script-api/script-api-1.0.ebuild,v 1.3 2013/01/30 18:09:12 ago Exp $

EAPI=4

inherit java-virtuals-2

DESCRIPTION="Virtual for Java Scripting API (jsr223)"
HOMEPAGE="http://www.gentoo.org"
SRC_URI=""

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	|| (
		>=virtual/jre-1.6
		dev-java/jsr223:0
	)"

JAVA_VIRTUAL_PROVIDES="jsr223"
JAVA_VIRTUAL_VM=">=virtual/jre-1.6"
