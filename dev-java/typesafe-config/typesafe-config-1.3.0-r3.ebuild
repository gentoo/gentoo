# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A library of arguably useful Java utilities"
HOMEPAGE="https://lightbend.github.io/config/"
SRC_URI="https://github.com/lightbend/config/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"
IUSE="doc source"

RDEPEND=">=virtual/jre-1.8:*"

DEPEND=">=virtual/jdk-1.8:*"
