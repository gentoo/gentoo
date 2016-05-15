# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit java-virtuals-2

DESCRIPTION="Virtual for SAAJ 1.3 (AKA JSR-67 MR3) API"
HOMEPAGE="https://www.gentoo.org"
SRC_URI=""

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-fbsd"
IUSE=""

RDEPEND="|| (
			>=virtual/jre-1.6
			dev-java/jsr67:0
		)"

JAVA_VIRTUAL_PROVIDES="jsr67"
JAVA_VIRTUAL_VM=">=virtual/jre-1.6"
