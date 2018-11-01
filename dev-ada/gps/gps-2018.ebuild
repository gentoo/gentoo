# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
inherit python-single-r1 autotools desktop

MYP=${PN}-gpl-${PV}-src

DESCRIPTION="The GNAT Programming Studio"
HOMEPAGE="http://libre.adacore.com/tools/gps/"
SRC_URI="http://mirrors.cdn.adacore.com/art/5b0cf627c7a4475261f97ceb
	-> ${MYP}.tar.gz
	http://mirrors.cdn.adacore.com/art/5b0819dfc7a447df26c27a59 ->
		libadalang-tools-gpl-2018-src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="${PYTHON_DEPS}
	dev-ada/gnatcoll-db[gnatcoll_db2ada,gnatinspect,xref]
	dev-ada/gnatcoll-bindings[python]
	>=dev-ada/gtkada-2017[gnat_2018]
	dev-ada/libadalang[gnat_2018]
	dev-libs/gobject-introspection
	dev-libs/libffi
	sys-devel/clang:=
	x11-themes/adwaita-icon-theme
	x11-themes/hicolor-icon-theme
	dev-python/pep8[${PYTHON_USEDEP}]
	dev-python/jedi[${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}"

RESTRICT="test"

S="${WORKDIR}"/${MYP}

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_prepare() {
	GCC_PV=7.3.1
	default
	sed -i \
	-e "s:@GNATMAKE@:${CHOST}-gnatmake-${GCC_PV}:g" \
	-e "s:@GNAT@:${CHOST}-gnat-${GCC_PV}:g" \
	-e "s:@GNATLS@:${CHOST}-gnatls-${GCC_PV}:g" \
	share/support/core/toolchains.py \
	share/support/core/projects.py \
	|| die
	mv "${WORKDIR}"/libadalang-tools-src laltools
}

src_configure() {
	econf \
		GNATMAKE=/usr/bin/gnatmake-7.3.1 \
		GNATDRV=/usr/bin/gnat-7.3.1 \
		--with-clang=$(llvm-config --libdir)
}

src_compile() {
	CC=/usr/bin/gcc-7.3.1 emake -C gps GPRBUILD_FLAGS="-v ${MAKEOPTS}" \
		Build=Production
	gprbuild -v -p -Pcli/cli.gpr ${MAKEOPTS} -XLIBRARY_TYPE=relocatable \
		-cargs:Ada ${ADAFLAGS}
}

src_install() {
	default
	make_desktop_entry "${PN}" "GPS" "${EPREFIX}/usr/share/gps/icons/hicolor/32x32/apps/gps_32.png" "Development;IDE;"
}
