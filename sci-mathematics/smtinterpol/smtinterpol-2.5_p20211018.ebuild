# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

[[ ${PV} == *_p20211018 ]] && COMMIT=32d7fa8751f668f9e9a18e4e96df3337b53d2150

inherit java-pkg-2 java-ant-2

DESCRIPTION="Interpolating SMT-solver computing Craig interpolants for various theories"
HOMEPAGE="http://ultimate.informatik.uni-freiburg.de/smtinterpol/
	https://github.com/ultimate-pa/smtinterpol/"
SRC_URI="https://github.com/ultimate-pa/${PN}/archive/${COMMIT}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${COMMIT}

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND=">=virtual/jre-1.8"
DEPEND=">=virtual/jdk-1.8"

PATCHES=(
	"${FILESDIR}"/${PN}-Version.template-version.patch
	"${FILESDIR}"/${PN}-build.xml-basename.patch
)

src_prepare() {
	default
	java-pkg-2_src_prepare
}

src_compile() {
	eant all
}

src_install() {
	java-pkg_dojar dist/*.jar
	java-pkg_dolauncher ${PN} --jar ${PN}.jar

	einstalldocs
}
