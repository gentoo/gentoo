# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )
DISTUTILS_IN_SOURCE_BUILD=1
DISTUTILS_USE_SETUPTOOLS=no
inherit gnome2-utils distutils-r1

DESCRIPTION="Visual novel engine written in python"
HOMEPAGE="https://www.renpy.org"
SRC_URI="https://www.renpy.org/dl/${PV}/${P}-source.tar.bz2"

LICENSE="MIT"
SLOT=0
KEYWORDS="~amd64 ~x86"
IUSE="development doc examples"
REQUIRED_USE="examples? ( development )"

BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	virtual/pkgconfig"
DEPEND="
	dev-libs/fribidi
	~dev-python/pygame_sdl2-${PV}[${PYTHON_USEDEP}]
	>=dev-lang/python-exec-0.3[${PYTHON_USEDEP}]
	media-libs/glew:0
	media-libs/libpng:0
	media-libs/libsdl2[video]
	media-libs/freetype:2
	sys-libs/zlib
	media-video/ffmpeg"
RDEPEND="${DEPEND}
	!app-eselect/eselect-renpy"

S=${WORKDIR}/${P}-source

PATCHES=(
	"${FILESDIR}"/${P}-system-path.patch
	"${FILESDIR}"/${PN}-6.99.12.4-compat-style.patch
	"${FILESDIR}"/${PN}-6.99.12.4-compat-infinite-loop.patch
	"${FILESDIR}"/${P}-use-system-fribidi.patch
)

python_prepare_all() {
	einfo "Deleting precompiled python files"
	find . -name '*.py[co]' -print -delete || die
	rm -r module/{gen,fribidi-src} || die

	export CFLAGS="${CFLAGS} $($(tc-getPKG_CONFIG) --cflags fribidi)"
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
