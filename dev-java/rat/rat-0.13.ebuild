# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2

DESCRIPTION="Apache Rat is a release audit tool, focused on licenses."
HOMEPAGE="https://creadur.apache.org/rat/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	~dev-java/apache-rat-core-${PV}:0
	~dev-java/apache-rat-tasks-${PV}:0
	>=virtual/jre-1.8:*
"

S="${WORKDIR}"

src_compile() { :; }

src_install() {
	default
	java-pkg_register-dependency apache-rat-core,apache-rat-tasks
	java-pkg_dolauncher "apache-${PN}" --jar $(java-pkg_getjar apache-rat-core apache-rat-core.jar) --main org.apache.rat.Report
}
