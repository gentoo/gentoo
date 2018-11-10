# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit multilib python-r1 eutils versionator java-utils-2

MY_PV="$(replace_all_version_separators _)"
MY_P="Caver${MY_PV}_pymol_plugin"

DESCRIPTION="Calculation of pathways of proteins from buried cavities to outside solvent"
HOMEPAGE="http://loschmidt.chemi.muni.cz/caver/"
SRC_URI="${MY_P}.zip"

LICENSE="CAVER"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	>=virtual/jre-1.6
	sci-chemistry/pymol[${PYTHON_USEDEP}]
	${PYTHON_DEPS}"
DEPEND="app-arch/unzip
	${PYTHON_DEPS}"

RESTRICT="fetch"

S="${WORKDIR}/${MY_P}"/linux_mac

pkg_nofetch() {
	elog "Download ${A}"
	elog "from ${HOMEPAGE}. This requires registration."
	elog "Place tarballs in ${DISTDIR}."
}

src_install() {
	java-pkg_dojar Caver${MY_PV}/*.jar

	java-pkg_jarinto /usr/share/${PN}/lib/lib/
	java-pkg_dojar Caver${MY_PV}/lib/*.jar

	installation() {
		sed \
			-e "s:directory/where/jar/with/plugin/is/located:${EPREFIX}/usr/share/${PN}/lib/:g" \
			-i Caver${MY_PV}.py || die

		python_moduleinto pmg_tk/startup/
		python_domodule Caver${MY_PV}.py
		python_optimize
	}
	python_foreach_impl installation
}
