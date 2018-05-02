# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit desktop python-single-r1

DESCRIPTION="A single-player game with a science-fiction theme"
HOMEPAGE="http://www.jwhitham.org/20kly/"
SRC_URI="http://www.jwhitham.org/20kly/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
REQUIRED_USE=${PYTHON_REQUIRED_USE}

RDEPEND="${PYTHON_DEPS}
	dev-python/pygame[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eapply "${FILESDIR}/${P}"-gentoo.patch
	sed -i \
		-e "s:@GENTOO_LIBDIR@:/usr/$(get_libdir)/${PN}:" \
		-e "s:@GENTOO_DATADIR@:/usr/share/${PN}:" \
		${PN} || die
	python_fix_shebang .
}

src_install() {
	dobin ${PN}

	insinto /usr/"$(get_libdir)/${PN}"
	doins code/*.py

	einstalldocs

	insinto "/usr/share/${PN}"
	doins -r audio data manual

	python_optimize "${ED}/usr/$(get_libdir)/${PN}"

	newicon data/32.png ${PN}.png
	make_desktop_entry ${PN} "Light Years Into Space"
}
