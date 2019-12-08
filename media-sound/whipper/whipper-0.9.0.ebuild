# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="A Python CD-DA ripper preferring accuracy over speed (forked from morituri)"
HOMEPAGE="https://github.com/whipper-team/whipper"
SRC_URI="https://github.com/whipper-team/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT+=" !test? ( test )"

BDEPEND="test? ( dev-python/twisted[${PYTHON_USEDEP}] )"
COMMON_DEPEND="media-libs/libsndfile"
DEPEND="${COMMON_DEPEND}"
RDEPEND="
	${COMMON_DEPEND}
	app-cdr/cdrdao
	>=dev-libs/libcdio-paranoia-0.94_p2
	>=dev-python/pycdio-2.1.0[${PYTHON_USEDEP}]
	dev-python/pygobject:=[${PYTHON_USEDEP}]
	dev-python/python-musicbrainz-ngs[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/ruamel-yaml[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	media-libs/mutagen[${PYTHON_USEDEP}]
	media-sound/sox[flac]
"

PATCHES=(
	"${FILESDIR}/${PN}-0.7.0-cdparanoia-name-fix.patch"
	"${FILESDIR}/${PN}-0.7.0-src-Makefile-respect-CFLAGS.patch"
)

python_prepare_all() {
	# accurip test totally depends on network access
	rm "${PN}"/test/test_common_accurip.py || die

	distutils-r1_python_prepare_all
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
