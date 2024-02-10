# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo java-pkg-2

DESCRIPTION="A BQN language implementation written in Java, also know as dbqn"
HOMEPAGE="https://github.com/dzaima/BQN/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/dzaima/BQN.git"
else
	SRC_URI="https://github.com/dzaima/BQN/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/BQN-${PV}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"

RDEPEND=">=virtual/jre-1.8"
DEPEND=">=virtual/jdk-1.8"

BUILD_DIR="${WORKDIR}/${P}_BuildDir"
BUILD_JAR="${BUILD_DIR}/dbqn.jar"

DOCS=( readme.md )

src_prepare() {
	default
	java-pkg-2_src_prepare

	mkdir -p "${BUILD_DIR}" || die
}

src_compile() {
	# This is the "build8" (or "build") script rewritten for our purposes.

	ejavac -d "${BUILD_DIR}" $(find ./src -name "*.java")

	cd "${BUILD_DIR}" || die
	edob jar cvfe "${BUILD_JAR}" BQN.Main BQN
}

src_test() {
	edob java -jar "${BUILD_JAR}" -f "${S}"/test/test
}

src_install() {
	java-pkg_dojar "${BUILD_JAR}"
	java-pkg_dolauncher dbqn --jar dbqn.jar

	einstalldocs
}

pkg_postinst() {
	einfo "The ${CATEGORY}/${PN} installs the main executable under the name \"dbqn\"."
}
