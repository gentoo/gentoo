# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Bean Validation (JSR-303) API"
HOMEPAGE="https://beanvalidation.org/"
SRC_URI="https://repository.jboss.org/nexus/service/local/repo_groups/public/content/javax/validation/${PN}/${PV}.GA/${P}.GA-sources.jar"

LICENSE="Apache-2.0"
SLOT="1.0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"
BDEPEND="app-arch/unzip"
