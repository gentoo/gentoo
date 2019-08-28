# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit desktop gnome2-utils distutils-r1

MY_PN="${PN/outerspace/Outer Space}"
DESCRIPTION="On-line strategy game taking place in the dangerous universe"
HOMEPAGE="https://www.ospace.net/ https://sourceforge.net/projects/ospace/"
SRC_URI="mirror://sourceforge/ospace/Client/${PV}/Outer%20Space-${PV}.tar.gz -> ${P}.tar.gz
	mirror://sourceforge/ospace/Client/${PV}/outerspace_${PV}-0ubuntu1_all.deb"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-python/pygame-1.7"
DEPEND=""

S="${WORKDIR}/${MY_PN}-${PV}"

src_unpack() {
	default
	unpack ./data.tar.gz
}

python_install() {
	distutils-r1_python_install \
		--install-scripts="/usr/bin" \
		--install-data="/usr/share/${PN}" \
		--install-lib="$(python_get_sitedir)"

	# source tarball is missing files
	# get them from ubuntu.deb
	python_moduleinto ige.ospace.Rules
	python_domodule "${WORKDIR}"/usr/share/games/outerspace/libsrvr/ige/ospace/Rules/{Tech,techs}.spf
}

src_prepare() {
	default

	# fix setup script
	# rework python start script to avoid shell-wrapper script
	eapply "${FILESDIR}"/${P}-setup.patch

	sed -i\
		-e "s:@GENTOO_DATADIR@:/usr/share/${PN}:" \
		osc.py || die "sed failed"

	distutils-r1_src_prepare
}

src_install() {
	distutils-r1_src_install
	newicon res/logo-login.png ${PN}.png
	make_desktop_entry "osc.py" "${MY_PN}"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
