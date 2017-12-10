# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit versionator

SRC_URI="jdk-${PV}_doc-all.zip"
DESCRIPTION="Oracle's documentation bundle (including API) for Java SE"
HOMEPAGE="http://download.oracle.com/javase/$(get_version_component_range 1)/docs/"
LICENSE="oracle-java-documentation-$(get_version_component_range 1)"
SLOT="$(get_version_component_range 1)"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux"

RESTRICT="fetch"

DEPEND="app-arch/unzip"

S="${WORKDIR}/docs"

src_install(){
	insinto /usr/share/doc/${P}/html
	doins -r index.html */
}
