# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
inherit python-single-r1 autotools

MYP=${PN}-gpl-${PV}-src

DESCRIPTION="The GNAT Programming Studio"
HOMEPAGE="http://libre.adacore.com/tools/gps/"
SRC_URI="http://mirrors.cdn.adacore.com/art/591c45e2c7a447af2deed03b
	-> ${MYP}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="${PYTHON_DEPS}
	>=dev-ada/gnatcoll-2017[gtk,iconv,projects,pygobject,shared,sqlite,tools]
	>=dev-ada/gtkada-2017
	dev-ada/libadalang
	dev-libs/gobject-introspection
	dev-libs/libffi
	sys-devel/llvm:=
	sys-devel/clang:=
	x11-themes/adwaita-icon-theme
	x11-themes/hicolor-icon-theme
	dev-python/pep8[${PYTHON_USEDEP}]
	dev-python/jedi[${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}"

S="${WORKDIR}"/${MYP}

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

pkg_setup() {
	GCC=${ADA:-$(tc-getCC)}
	GNATLS="${GCC/gcc/gnatls}"
	GNAT="${GCC/gcc/gnat}"
	GNATMAKE="${GCC/gcc/gnatmake}"
	if [[ -z "$(type ${GNATLS} 2>/dev/null)" ]] ; then
		eerror "You need a gcc compiler that provides the Ada Compiler:"
		eerror "1) use gcc-config to select the right compiler or"
		eerror "2) set ADA=gcc-6.3.0 in make.conf"
		die "ada compiler not available"
	fi
	python-single-r1_pkg_setup
}

src_prepare() {
	default
	mv configure.{in,ac} || die
	sed -i \
		-e "s:@GNATMAKE@:${GNATMAKE}:g" \
		-e "s:@GNAT@:${GNAT}:g" \
		aclocal.m4 \
		|| die
	eautoreconf
}

src_compile() {
	emake GPRBUILD_FLAGS="-v ${MAKEOPTS}"
}
