# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.eclipse.jdt:org.eclipse.jdt.annotation:2.2.800"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JDT Annotations for Enhanced Null Analysis"
HOMEPAGE="https://projects.eclipse.org/projects/eclipse.jdt"
SRC_URI="https://github.com/eclipse-jdt/eclipse.jdt.core/archive//R${PV//./_}.tar.gz -> eclipse.jdt.core-${PV}.tar.gz"
S="${WORKDIR}/eclipse.jdt.core-R${PV//./_}/org.eclipse.jdt.annotation"

LICENSE="EPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=virtual/jre-1.8:*"
DEPEND=">=virtual/jdk-1.8:*"

JAVA_AUTOMATIC_MODULE_NAME="org.eclipse.jdt.annotation"
