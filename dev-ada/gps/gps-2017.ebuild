# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
inherit python-single-r1 autotools

MYP=${PN}-gpl-${PV}-src

DESCRIPTION="The GNAT Programming Studio"
HOMEPAGE="http://libre.adacore.com/tools/gps/"
SRC_URI="http://mirrors.cdn.adacore.com/art/591c45e2c7a447af2deed03b
	-> ${MYP}.tar.gz
	doc? ( http://mirrors.cdn.adacore.com/art/591c6d80c7a447af2deed1d7
			-> gnat-gpl-2017-x86_64-linux-bin.tar.gz )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

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

src_prepare() {
	default
	GCC_PV=6.3.0
	mv configure.{in,ac} || die
	sed -i \
		-e "s:@GNATMAKE@:gnatmake-${GCC_PV}:g" \
		-e "s:@GNAT@:gnat-${GCC_PV}:g" \
		-e "s:@GNATLS@:gnatls-${GCC_PV}:g" \
		aclocal.m4 \
		share/support/core/gnat_help_menus.py \
		share/support/core/toolchains.py \
		share/support/core/projects.py \
		cli/src/gps-cli_utils.adb \
		toolchains_editor/core/src/toolchains.adb \
		|| die
	eautoreconf
}

src_compile() {
	emake GPRBUILD_FLAGS="-v ${MAKEOPTS}"
}

src_install() {
	default
	if use doc; then
		insinto /usr/share/doc
		doins -r "${WORKDIR}"/gnat-gpl-2017-x86_64-linux-bin/share/doc/gnat
	fi
}
