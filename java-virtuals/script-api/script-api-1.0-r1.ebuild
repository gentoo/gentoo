# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit java-virtuals-2

DESCRIPTION="Virtual for Java Scripting API (jsr223)"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI=""

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 x86"
IUSE=""

RDEPEND="
	|| (
		>=virtual/jre-1.6
		dev-java/jsr223:0
	)"

JAVA_VIRTUAL_PROVIDES="jsr223"
JAVA_VIRTUAL_VM=">=virtual/jre-1.6"
