# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MYP="${PN}-$(ver_rs 1- '-')"

DESCRIPTION="Object Oriented Enhancements for Tcl/Tk"
HOMEPAGE="http://incrtcl.sourceforge.net/"
SRC_URI="https://github.com/tcltk/${PN}/archive/refs/tags/${MYP}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~alpha ~amd64 ~arm64 ~ia64 ~ppc ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"

RDEPEND=">=dev-lang/tcl-8.6:0="
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${MYP}"

# somehow broken
#RESTRICT=test

QA_CONFIG_IMPL_DECL_SKIP=(
	stat64 opendir64 rewinddir64 closedir64 # used to test for Large File Support
)

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_prepare() {
	default
	cp -r itclWidget/tclconfig tclconfig || die
	echo "git-a3e8b43c671afc7f0d82bd892325d42c813791ab" > manifest.uuid
	eautoreconf
}

src_configure() {
	econf \
		--with-tcl="${EPREFIX}"/usr/$(get_libdir) \
		--with-tclinclude="${EPREFIX}"/usr/include \
		--disable-rpath
}

src_compile() {
	# adjust install_name on darwin
	if [[ ${CHOST} == *-darwin* ]]; then
		sed -i \
			-e 's:^\(SHLIB_LD\W.*\)$:\1 -install_name ${pkglibdir}/$@:' \
			"${S}"/Makefile || die 'sed failed'
	fi

	sed 's:-pipe::g' -i Makefile || die

	emake CFLAGS_DEFAULT="${CFLAGS}"
}

src_install() {
	default

	local MY_P=${PN}${PV}

	sed \
		-e "/BUILD_LIB_SPEC/s:-L${S}::g" \
		-e "/BUILD_STUB_LIB_SPEC/s:-L${S}::g" \
		-e "/BUILD_STUB_LIB_PATH/s:${S}:${EPREFIX}/usr/$(get_libdir)/${MY_P}/:g" \
		-e "/INCLUDE_SPEC/s:${S}/generic:${EPREFIX}/usr/include:g" \
		-e "s:${S}:${EPREFIX}/usr/$(get_libdir)/${MY_P}/:g" \
		-i "${ED}"/usr/$(get_libdir)/${MY_P}/itclConfig.sh || die

	cat >> "${T}"/34${PN} <<- EOF
	LDPATH="${EPREFIX}/usr/$(get_libdir)/${MY_P}/"
	EOF
	doenvd "${T}"/34${PN}
}
