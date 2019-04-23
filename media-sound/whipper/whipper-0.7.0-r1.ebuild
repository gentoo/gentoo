# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A Python CD-DA ripper preferring accuracy over speed (forked from morituri)"
HOMEPAGE="https://github.com/whipper-team/whipper"
SRC_URI="https://github.com/whipper-team/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	media-libs/libsndfile
	test? ( dev-python/twisted[${PYTHON_USEDEP}] )
"
RDEPEND="
	app-cdr/cdrdao
	>=dev-libs/libcdio-paranoia-0.94_p2
	dev-python/cddb-py[${PYTHON_USEDEP}]
	dev-python/pycdio[${PYTHON_USEDEP}]
	dev-python/pygobject:2=[${PYTHON_USEDEP}]
	dev-python/python-musicbrainz-ngs[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	media-libs/flac
	media-libs/libsndfile
	media-libs/mutagen[${PYTHON_USEDEP}]
	media-sound/sox[flac]
"

PATCHES=(
	"${FILESDIR}/${P}-cdparanoia-name-fix.patch"
	"${FILESDIR}/${P}-src-Makefile-respect-CFLAGS.patch"
)

src_prepare() {
	# accurip test totally depends on network access
	rm "${PN}"/test/test_common_accurip.py || die

	distutils-r1_src_prepare
}

src_compile() {
	distutils-r1_src_compile
	emake -C src CC="$(tc-getCC)"
}

python_test() {
	"${EPYTHON}" -m unittest discover -v || die "Tests fail with ${EPYTHON}"
}

src_install() {
	distutils-r1_src_install
	emake PREFIX="${EPREFIX}/usr" DESTDIR="${D}" -C src install
}
