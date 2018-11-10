# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit desktop eutils python-single-r1

DESCRIPTION="An Alien Invaders style game with 3d graphics"
HOMEPAGE="http://triplexinvaders.infogami.com"
SRC_URI="http://acm.jhu.edu/~arthur/invaders/${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-python/pygame[${PYTHON_USEDEP}]
	dev-python/pyopengl[${PYTHON_USEDEP}]
"
DEPEND="app-arch/unzip"

src_prepare() {
	default
	eapply "${FILESDIR}/${P}"-gentoo.patch
	sed -i -e "s:@GENTOO_DATADIR@:/usr/share/${PN}:" \
		sound.py \
		util.py \
		hiscore.py \
		options.py || die "sed failed"
}

src_install() {
	local libdir=/usr/$(get_libdir)

	insinto "${libdir}/${PN}"
	doins -r *.py
	insinto "/usr/share/${PN}"
	doins -r models sound options.conf hiscores
	make_wrapper ${PN} "python2 ./invaders.py" "${libdir}/${PN}"
	einstalldocs
	make_desktop_entry ${PN}
}
