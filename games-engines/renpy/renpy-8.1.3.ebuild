# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
inherit desktop gnome2-utils distutils-r1

DESCRIPTION="Visual novel engine written in python"
HOMEPAGE="https://www.renpy.org"
SRC_URI="https://www.renpy.org/dl/${PV}/${P}-source.tar.bz2"
S="${WORKDIR}/${P}-source"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="development doc examples"
REQUIRED_USE="examples? ( development )"

BDEPEND="
	$(python_gen_cond_dep '<dev-python/cython-3[${PYTHON_USEDEP}]')
	virtual/pkgconfig"
DEPEND="
	dev-libs/fribidi
	$(python_gen_cond_dep '
		>=dev-python/pygame_sdl2-8.1.1[${PYTHON_USEDEP}]
		>=dev-lang/python-exec-0.3[${PYTHON_USEDEP}]
		dev-python/ecdsa[${PYTHON_USEDEP}]
	')
	media-libs/glew:0
	media-libs/libpng:0
	media-libs/libsdl2[video]
	media-libs/freetype:2
	sys-libs/zlib
	media-video/ffmpeg:=
"
RDEPEND="${DEPEND}
	!app-eselect/eselect-renpy"

PATCHES=(
	"${FILESDIR}/renpy-6.99.12.4-compat-style.patch"
	"${FILESDIR}/renpy-6.99.12.4-compat-infinite-loop.patch"
	"${FILESDIR}/renpy-8.1.0-ignore_rpyc_errors.patch"
	"${FILESDIR}/renpy-8.1.3-system-path.patch"
)

python_prepare_all() {
	einfo "Deleting precompiled python files"
	find . -name '*.py[co]' -print -delete || die

	distutils-r1_python_prepare_all
}

python_compile() {
	cd "${S}"/module || die
	distutils-r1_python_compile
}

python_install() {
	cd "${S}"/module || die
	distutils-r1_python_install

	cd "${S}" || die
	python_newscript renpy.py ${PN}

	python_domodule renpy
	if use development ; then
		python_domodule launcher
	fi
	if use examples ; then
		python_domodule the_question tutorial
	fi
}

python_install_all() {
	distutils-r1_python_install_all
	if use development; then
		newicon -s 32 launcher/game/images/logo32.png ${P}.png
		make_desktop_entry ${PN} "Ren'Py ${PV}" ${P}
	fi

	if use doc; then
		insinto "/usr/share/doc/${PF}/html"
		doins -r doc/*
	fi
	newman "${FILESDIR}/${PN}.1" "${P}.1"
}

pkg_preinst() {
	use development && gnome2_icon_savelist
}

pkg_postinst() {
	use development && gnome2_icon_cache_update

	local v
	for v in ${REPLACING_VERSIONS}; do
		ver_test "${v}" -ge 7 && continue
		einfo "Starting from ${PN}-7 slots are dropped."
		einfo "RenPy natively supports compatibility with games made for older versions."
		einfo "Report bugs upstream on such problems, usually they are easy to fix."
		break
	done
}

pkg_postrm() {
	use development && gnome2_icon_cache_update
}
