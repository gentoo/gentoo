# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit eutils python-r1

MY_PN="Nagstamon"
MY_P="${MY_PN}-${PV/_}"

DESCRIPTION="Nagstamon is a systray monitor for displaying realtime status of a Nagios box"
HOMEPAGE="http://nagstamon.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gnome sound"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	dev-python/pygobject:2[${PYTHON_USEDEP}]
	dev-python/pygtk[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/beautifulsoup:python-2[${PYTHON_USEDEP}]
	dev-python/keyring[${PYTHON_USEDEP}]
	gnome-base/librsvg
	gnome? ( dev-python/egg-python[${PYTHON_USEDEP}] )
	sound? ( media-sound/sox )"

S="${WORKDIR}/${MY_PN}"

src_prepare() {
	epatch "${FILESDIR}/nagstamon-0.9.11_rc1-resources.patch"

	rm Nagstamon/resources/LICENSE
}

src_install() {
	# setup.py is broken
	cd Nagstamon/

	doman resources/nagstamon.1
	rm resources/nagstamon.1

	newbin ../nagstamon.py nagstamon

	insinto /usr/share/${PN}/resources
	doins resources/*

	domenu "${FILESDIR}"/${PN}.desktop

	nagstamon_install() {
		insinto $(python_get_sitedir)/${MY_PN}
		doins {GUI,Config,Objects,Custom,Actions}.py
		touch "${D}/$(python_get_sitedir)/${MY_PN}/__init__.py" || die
		doins -r Server/ thirdparty/
	}

	python_foreach_impl nagstamon_install

	python_replicate_script "${D}/usr/bin/nagstamon"
}
