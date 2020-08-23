# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

inherit desktop eutils python-single-r1 xdg

COMMIT="ea817f7e163c4fb07a60b2066c694cba92d23818"
DESCRIPTION="Short-term-memory training N-Back game"
HOMEPAGE="https://github.com/samcv/brainworkshop"
SRC_URI="https://github.com/samcv/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		>=dev-python/pyglet-1.5[${PYTHON_USEDEP},sound]
	')
"

BDEPEND="
	${PYTHON_DEPS}
"

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
	python_newscript ${PN}.pyw ${PN}

	insinto /usr/share/${PN}
	doins -r res/*

	dodoc Readme.md Readme-{instructions,resources}.txt data/Readme-stats.txt

	newicon -s 48 res/misc/brain/brain.png ${PN}.png
	make_desktop_entry ${PN} "Brain Workshop"
}
