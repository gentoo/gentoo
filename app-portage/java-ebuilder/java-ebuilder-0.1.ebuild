# Copyright 2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

if [[ ${PV} == 9999 ]]; then
	ECLASS="git-r3"
	EGIT_REPO_URI="https://github.com/heroxbd/${PN}.git"
else
	SRC_URI="https://github.com/gentoo/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

inherit java-pkg-2 java-pkg-simple prefix ${ECLASS}

DESCRIPTION="Java team tool for semi-automatic creation of ebuilds from pom.xml"
HOMEPAGE="https://github.com/gentoo/java-ebuilder"

LICENSE="GPL-2"
SLOT="0"

DEPEND=">=virtual/jdk-1.8"
RDEPEND=">=virtual/jre-1.8
	sys-process/parallel
	>=dev-java/maven-bin-3"

S="${WORKDIR}/${P}"

JAVA_SRC_DIR="src/main/java"
JAVA_ADDRES_DIRS="src/main/resources"

MAIN_CLASS="org.gentoo.java.ebuilder.Main"

java_prepare() {
	eapply_user
	local base_dir="target/classes/"
	[[ ! -d "${base_dir}" ]] &&mkdir -p "${base_dir}META-INF"
	echo "Manifest-Version: 1.0
Main-Class: ${MAIN_CLASS}" \
		>> "${base_dir}META-INF/MANIFEST.MF"
}

src_prepare() {
	hprefixify scripts/{{tree,meta}.sh,movl} java-ebuilder.conf
	eapply_user
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_dolauncher ${PN} --main ${MAIN_CLASS}

	insinto /var/lib/${PN}
	doins -r maven
	dodir /var/lib/${PN}/{poms,cache}

	dodoc README maven.conf

	exeinto /usr/lib/${PN}
	doexe scripts/{tree,meta}.sh

	dobin scripts/movl

	insinto /etc
	doins java-ebuilder.conf
}
