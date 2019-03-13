# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
inherit python-single-r1 autotools desktop

MYP=${PN}-gpl-${PV}-src

DESCRIPTION="The GNAT Programming Studio"
HOMEPAGE="http://libre.adacore.com/tools/gps/"
SRC_URI="http://mirrors.cdn.adacore.com/art/591c45e2c7a447af2deed03b
	-> ${MYP}.tar.gz
	doc? ( http://mirrors.cdn.adacore.com/art/591c6d80c7a447af2deed1d7
			-> gnat-gpl-2017-x86_64-linux-bin.tar.gz )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc gnat_2016 +gnat_2017 gnat_2018"

RDEPEND="${PYTHON_DEPS}
	dev-ada/gnatcoll[gtk,iconv,pygobject,sqlite,static-libs,tools]
	~dev-ada/gtkada-2017
	dev-ada/libadalang
	dev-libs/gobject-introspection
	dev-libs/libffi
	sys-devel/clang:=
	x11-themes/adwaita-icon-theme
	x11-themes/hicolor-icon-theme
	dev-python/pep8[${PYTHON_USEDEP}]
	dev-python/jedi[${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	^^ ( gnat_2016 gnat_2017 ) !gnat_2018"

RESTRICT="test"

S="${WORKDIR}"/${MYP}

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_prepare() {
	default
	if use gnat_2016; then
		GCC_PV=4.9.4
	else
		GCC_PV=6.3.0
	fi
	mv configure.{in,ac} || die
	sed -i \
		-e "s:@GNATMAKE@:${CHOST}-gnatmake-${GCC_PV}:g" \
		-e "s:@GNAT@:${CHOST}-gnat-${GCC_PV}:g" \
		-e "s:@GNATLS@:${CHOST}-gnatls-${GCC_PV}:g" \
		aclocal.m4 \
		share/support/core/gnat_help_menus.py \
		share/support/core/toolchains.py \
		share/support/core/projects.py \
		cli/src/gps-cli_utils.adb \
		toolchains_editor/core/src/toolchains.adb \
		|| die
	eautoreconf
}

src_configure() {
	econf \
		--with-clang=$(llvm-config --libdir)
}

src_compile() {
	ADAFLAGS+=" -fno-strict-aliasing"
	emake GPRBUILD_FLAGS="-v ${MAKEOPTS} \
		-XLIBRARY_TYPE=relocatable \
		-XGPR_BUILD=relocatable \
		-XXMLADA_BUILD=relocatable"
}

src_install() {
	default
	if use doc; then
		insinto /usr/share/doc
		doins -r "${WORKDIR}"/gnat-gpl-2017-x86_64-linux-bin/share/doc/gnat
	fi
	make_desktop_entry "${PN}" "GPS" "${EPREFIX}/usr/share/gps/icons/hicolor/32x32/apps/gps_32.png" "Development;IDE;"
}
