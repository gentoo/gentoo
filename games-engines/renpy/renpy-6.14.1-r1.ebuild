# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
DISTUTILS_IN_SOURCE_BUILD=1
inherit eutils python-r1 versionator gnome2-utils games distutils-r1

DESCRIPTION="Visual novel engine written in python"
HOMEPAGE="http://www.renpy.org"
SRC_URI="http://www.renpy.org/dl/${PV}/${P}-source.tar.bz2"

LICENSE="MIT"
SLOT="$(get_version_component_range 1-2)"
MYSLOT=$(delete_all_version_separators ${SLOT})
KEYWORDS="amd64 x86"
IUSE="development doc examples"
REQUIRED_USE="examples? ( development )"

RDEPEND="
	>=app-eselect/eselect-renpy-0.1
	dev-libs/fribidi
	dev-python/pygame[X,${PYTHON_USEDEP}]
	>=dev-lang/python-exec-0.3[${PYTHON_USEDEP}]
	media-libs/glew
	media-libs/libpng:0
	media-libs/libsdl[X,video]
	media-libs/freetype:2
	sys-libs/zlib
	virtual/ffmpeg"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${P}-source

pkg_setup() {
	games_pkg_setup
	export CFLAGS="${CFLAGS} $(pkg-config --cflags fribidi)"
}

python_prepare_all() {
	# wooosh! this should fix multiple abi
	epatch "${FILESDIR}"/${P}-multiple-abi.patch \
		"${FILESDIR}"/${P}-{av_close_input_stream,remove-AVFormatParameters}.patch \
		"${FILESDIR}"/${P}-freetype.patch

	einfo "Deleting precompiled python files"
	find . -name '*.py[co]' -print -delete || die

	sed -i \
		-e "s/@SLOT@/${MYSLOT}/" \
		renpy.py renpy/common.py || die "setting slot failed!"

	distutils-r1_python_prepare_all
}

python_compile() {
	cd "${S}"/module || die
	distutils-r1_python_compile
}

python_install() {
	cd "${S}"/module || die
	distutils-r1_python_install --install-lib="$(python_get_sitedir)/renpy${MYSLOT}"

	cd "${S}" || die
	python_scriptinto "${GAMES_BINDIR}"
	python_newscript renpy.py ${PN}-${SLOT}

	python_moduleinto renpy${MYSLOT}
	python_domodule renpy common
	if use development ; then
		python_domodule launcher template
	fi
	if use examples ; then
		python_domodule the_question tutorial
	fi
}

python_install_all() {
	if use development; then
		newicon -s 32 launcher/game/logo32.png ${P}.png
		make_desktop_entry ${PN}-${SLOT} "Ren'Py ${PV}" ${P}
	fi

	if use doc; then
		dohtml -r doc
	fi

	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	use development && gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	use development && gnome2_icon_cache_update

	einfo "running: eselect renpy update --if-unset"
	eselect renpy update --if-unset
}

pkg_postrm() {
	use development && gnome2_icon_cache_update

	einfo "running: eselect renpy update --if-unset"
	eselect renpy update --if-unset
}
