# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
inherit desktop python-single-r1

HASH_BWORKSHOP=31b125162c63c111358ead73d9c02905363c8c1c

DESCRIPTION="Short-term-memory training N-Back game"
HOMEPAGE="https://github.com/brain-workshop/brainworkshop/"
SRC_URI="
	https://github.com/brain-workshop/brainworkshop/archive/${HASH_BWORKSHOP}.tar.gz
		-> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${HASH_BWORKSHOP}"

LICENSE="CC-Sampling-Plus-1.0 GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep 'dev-python/pyglet[${PYTHON_USEDEP},sound]')"
BDEPEND="${PYTHON_DEPS}"

PATCHES=(
	"${FILESDIR}"/${PN}-5.0.2-datadir.patch
)

src_prepare() {
	default

	sed -i "s|@GENTOO_DATADIR@|${EPREFIX}/usr/share/${PN}|" ${PN}.py || die

	python_fix_shebang ${PN}.py
}

src_install() {
	newbin ${PN}.py ${PN}

	insinto /usr/share/${PN}
	doins -r res/.

	dodoc Readme.md Readme-{instructions,resources}.txt data/Readme-stats.txt

	domenu ${PN}.desktop
	newicon res/misc/brain/brain.png ${PN}.png
}
