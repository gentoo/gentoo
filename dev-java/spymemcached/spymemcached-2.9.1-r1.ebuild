# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-pkg-simple

DESCRIPTION="A simple, asynchronous, single-threaded memcached client written in java"
HOMEPAGE="https://code.google.com/p/spymemcached/"
SRC_URI="https://${PN}.googlecode.com/files/${P}-sources.jar"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

CDEPEND="dev-java/log4j:0
	dev-java/slf4j-api:0"

DEPEND=">=virtual/jdk-1.5
	${CDEPEND}"

RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"

S="${WORKDIR}"

JAVA_GENTOO_CLASSPATH="log4j,slf4j-api"

java_prepare() {
	rm net/spy/memcached/spring/MemcachedClientFactoryBean.java || die
}
