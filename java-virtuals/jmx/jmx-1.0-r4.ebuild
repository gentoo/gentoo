# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit java-virtuals-2

DESCRIPTION="Virtual for Java Management Extensions (JMX)"
HOMEPAGE="https://www.gentoo.org"
SRC_URI=""

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

RDEPEND="
	|| (
		virtual/jre:1.8
		virtual/jre:1.7
		virtual/jre:1.6
		virtual/jre:1.5
		dev-java/sun-jmx:0
	)"

JAVA_VIRTUAL_PROVIDES="sun-jmx"
JAVA_VIRTUAL_VM="=virtual/jre-1.8 =virtual/jre-1.7 =virtual/jre-1.6 =virtual/jre-1.5"
