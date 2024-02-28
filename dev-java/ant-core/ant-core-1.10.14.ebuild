# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2

DESCRIPTION="Compatibility link to ant-core for >=dev-java/ant-1.10.14"
HOMEPAGE="https://ant.apache.org/"
S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc64 ~x86"

DEPEND="
	~dev-java/ant-${PV}:0
	>=virtual/jdk-1.8:*
"
RDEPEND=">=virtual/jre-1.8:*"

src_compile() { :; }

src_install() {
	java-pkg_regjar /usr/share/ant-core/lib/ant.jar
}
