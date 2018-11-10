# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python2_7 )
inherit eutils distutils-r1 versionator

MY_PN="PythonCAD"
MY_PV="DS$(get_major_version)-R$(get_after_major_version)"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="CAD program written in PyGTK"
HOMEPAGE="https://sourceforge.net/projects/pythoncad"
SRC_URI="mirror://sourceforge/pythoncad/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/pygtk:2[${PYTHON_USEDEP}]"
DEPEND=""

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}/${P}-png.patch" )

python_prepare_all() {
	distutils-r1_python_prepare_all
	sed -i \
		-e "s/gtkpycad.png/pythoncad.png/" \
		-e "s/gtkpycad.py/pythoncad/" \
		"${PN}.desktop" || die "sed failed"
}

python_install() {
	distutils-r1_python_install
	python_newscript gtkpycad.py pythoncad
}

src_install() {
	distutils-r1_src_install

	insinto /etc/"${PN}"
	doins prefs.py
	domenu "${PN}".desktop
	newicon gtkpycad.png "${PN}".png
}
