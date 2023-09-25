# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="javax.persistence:javax.persistence-api:${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Persistence API"
HOMEPAGE="https://www.jcp.org/en/jsr/detail?id=220"
SRC_URI="https://repo1.maven.org/maven2/javax/persistence/${PN/-/.}/${PV}/${PN/-/.}-${PV}-sources.jar"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

BDEPEND="app-arch/unzip"
DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_RESOURCE_DIRS="resources"

src_prepare() {
	java-pkg-2_src_prepare

	# java-pkg-simple.eclass wants resources in JAVA_RESOURCE_DIRS
	mkdir resources || die
	find -type f \
		-name '*.xsd' \
		| xargs cp --parent -t resources || die
}
