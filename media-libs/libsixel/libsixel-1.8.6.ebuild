# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python3_{7..10} )
DISTUTILS_OPTIONAL="1"

inherit bash-completion-r1 distutils-r1

DESCRIPTION="A lightweight, fast implementation of DEC SIXEL graphics codec"
HOMEPAGE="https://github.com/saitoha/libsixel"
SRC_URI="https://github.com/saitoha/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT public-domain"
SLOT="0"
KEYWORDS="amd64 ~ia64 x86"
IUSE="curl gd gtk jpeg png python static-libs"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="curl? ( net-misc/curl )
	gd? ( media-libs/gd )
	gtk? ( x11-libs/gdk-pixbuf:2 )
	jpeg? ( virtual/jpeg:0 )
	png? ( media-libs/libpng:0 )
	python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	python? (
		${PYTHON_DEPS}
		dev-python/setuptools[${PYTHON_USEDEP}]
	)"

src_prepare() {
	default
	if use python; then
		cd python || die
		distutils-r1_src_prepare
		cd - >/dev/null || die
	fi
}

src_configure() {
	econf \
		$(use_with curl libcurl) \
		$(use_with gd) \
		$(use_with gtk gdk-pixbuf2) \
		$(use_with jpeg) \
		$(use_with png) \
		$(use_enable static-libs static) \
		--with-bashcompletiondir=$(get_bashcompdir) \
		--disable-python
	if use python; then
		cd python || die
		distutils-r1_src_configure
		cd - >/dev/null || die
	fi
}

src_compile() {
	default
	if use python; then
		cd python || die
		distutils-r1_src_compile
		cd - >/dev/null || die
	fi
}

src_test() {
	emake test
}

src_install() {
	default
	use static-libs || find "${ED}" -name '*.la' -delete || die

	cd images || die
	docompress -x /usr/share/doc/${PF}/images
	docinto images
	dodoc egret.jpg map{8,16}.png snake.jpg vimperator3.png
	cd - >/dev/null || die

	if use python; then
		cd python || die
		distutils-r1_src_install
		cd - >/dev/null || die
	fi
}
