# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit versionator

SRC_URI="http://download.java.net/java/jdk$(get_version_component_range 1)/archive/$(get_version_component_range 4)/binaries/jdk-$(get_version_component_range 1)_doc-api-spec.tar.gz -> ${P}.tar.gz"
DESCRIPTION="Oracle's documentation bundle (including API) for Java SE"
HOMEPAGE="http://jdk.java.net/$(get_version_component_range 1)/"
LICENSE="Oracle-EADLA" # will probably change to oracle-java-documentation-9 (or something like it) when released
SLOT="$(get_version_component_range 1)"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux"

DEPEND="app-arch/unzip"

S="${WORKDIR}/docs"

src_install(){
	insinto /usr/share/doc/${P}/html
	doins -r index.html */
}
