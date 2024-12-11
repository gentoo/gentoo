# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="javax.servlet:servlet-api:2.5"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JavaServlet(TM) Specification"
HOMEPAGE="https://javaee.github.io/servlet-spec/"
SRC_URI="https://repo1.maven.org/maven2/javax/servlet/servlet-api/${PV}/servlet-api-${PV}-sources.jar"

LICENSE="CDDL GPL-2"
SLOT="2.5"
KEYWORDS="amd64 arm64 ppc64"

RDEPEND=">=virtual/jre-1.8:*"
DEPEND=">=virtual/jdk-1.8:*"

JAVA_RESOURCES=(
	"dtd/*                           -> javax/servlet/resources"
	"javax/servlet/*.properties      -> javax/servlet"
	"javax/servlet/http/*.properties -> javax/servlet/http"
)
