# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
DISTUTILS_IN_SOURCE_BUILD=1
inherit eutils gnome2-utils toolchain-funcs versionator distutils-r1

DESCRIPTION="Visual novel engine written in python"
HOMEPAGE="https://www.renpy.org"
SRC_URI="https://www.renpy.org/dl/${PV}/${P}-source.tar.bz2"

LICENSE="MIT"
SLOT="$(get_version_component_range 1-2)"
MYSLOT=$(delete_all_version_separators ${SLOT})
KEYWORDS="amd64 x86"
IUSE="development doc examples"
REQUIRED_USE="examples? ( development )"

RDEPEND="
	>=app-eselect/eselect-renpy-0.7
	dev-libs/fribidi
	~dev-python/pygame_sdl2-${PV}[${PYTHON_USEDEP}]
	>=dev-lang/python-exec-0.3[${PYTHON_USEDEP}]
	media-libs/glew:0
	media-libs/libpng:0
	media-libs/libsdl2[video]
	media-libs/freetype:2
	sys-libs/zlib
	media-video/ffmpeg"
DEPEND="${RDEPEND}
	dev-python/cython[${PYTHON_USEDEP}]
	virtual/pkgconfig"

S=${WORKDIR}/${P}-source

PATCHES=(
	"${FILESDIR}"/${P}-multiple-abi.patch
	"${FILESDIR}"/${P}-compat-window.patch #601200
	"${FILESDIR}"/${P}-compat-style.patch
	"${FILESDIR}"/${P}-compat-infinite-loop.patch
)

python_prepare_all() {
	export CFLAGS="${CFLAGS} $($(tc-getPKG_CONFIG) --cflags fribidi)"
	distutils-r1_python_prepare_all

	einfo "Deleting precompiled python files"
	find . -name '*.py[co]' -print -delete || die

	sed -i \
		-e "s/@SLOT@/${MYSLOT}/" \
		renpy.py renpy/common.py || die "setting slot failed!"
}

python_compile() {
	cd "${S}"/module || die
	distutils-r1_python_compile
}

python_install() {
	cd "${S}"/module || die
	distutils-r1_python_install --install-lib="$(python_get_sitedir)/renpy${MYSLOT}"

	cd "${S}" || die
	python_newscript renpy.py ${PN}-${SLOT}

	python_moduleinto renpy${MYSLOT}
	python_domodule renpy
	if use development ; then
		python_domodule launcher templates
	fi
	if use examples ; then
		python_domodule the_question tutorial
	fi
}

python_install_all() {
	distutils-r1_python_install_all
	if use development; then
		newicon -s 32 launcher/game/images/logo32.png ${P}.png
		make_desktop_entry ${PN}-${SLOT} "Ren'Py ${PV}" ${P}
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

	einfo "running: eselect renpy update --if-unset"
	eselect renpy update --if-unset
}

pkg_postrm() {
	use development && gnome2_icon_cache_update

	einfo "running: eselect renpy update --if-unset"
	eselect renpy update --if-unset
}
