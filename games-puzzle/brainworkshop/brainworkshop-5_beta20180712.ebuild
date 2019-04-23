# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )
inherit eutils gnome2-utils python-r1

COMMIT="c5343cb3d828e8181ffff8249f683fce2fcca6db"
DESCRIPTION="Short-term-memory training N-Back game"
HOMEPAGE="https://github.com/samcv/brainworkshop"
SRC_URI="https://github.com/samcv/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	|| ( >=dev-python/pyglet-1.1.4[${PYTHON_USEDEP},openal]
		 >=dev-python/pyglet-1.1.4[${PYTHON_USEDEP},alsa] )"

S="${WORKDIR}/${PN}-${COMMIT}"

PATCHES=(
	"${FILESDIR}"/${PN}-${PV%_*}-fix-paths.patch
)

src_prepare() {
	edos2unix ${PN}.pyw
	default

	sed -i \
		"s#@GENTOO_DATADIR@#${EPREFIX}/usr/share/${PN}#g" \
		${PN}.pyw || die
}

src_install() {
	newbin ${PN}.pyw ${PN}
	python_replicate_script "${ED}"usr/bin/${PN}

	insinto /usr/share/${PN}
	doins -r res/*

	dodoc Readme.md Readme-{instructions,resources}.txt data/Readme-stats.txt

	newicon -s 48 res/misc/brain/brain.png ${PN}.png
	make_desktop_entry ${PN} "Brain Workshop"
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
