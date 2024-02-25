# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

MY_P="tDOM-${PV}"

DESCRIPTION="A XML/DOM/XPath/XSLT Implementation for Tcl"
HOMEPAGE="https://core.tcl.tk/tdom/"
SRC_URI="http://tdom.org/downloads/${P}-src.tgz"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="threads"

DEPEND="
	dev-lang/tcl:0=
	dev-libs/expat"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${P}-src

PATCHES=( "${FILESDIR}"/${PN}-0.9.2-useCC.patch )

QA_CONFIG_IMPL_DECL_SKIP=(
	stat64 arc4random_buf arc4random # used to test for Large File Support
)

src_prepare() {
	append-libs -lm
	sed \
		-e 's:-O2::g' \
		-e 's:-pipe::g' \
		-e 's:-fomit-frame-pointer::g' \
		-e '/SHLIB_LD_LIBS/s:\"$: ${TCL_LIB_FLAG}":g' \
		-i tclconfig/tcl.m4 || die
	mv extensions/tnc/configure.{in,ac} || die
	mv extensions/example/configure.{in,ac} || die
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable threads)
		--enable-shared
		--with-tcl="${EPREFIX}"/usr/$(get_libdir)
		)

	cd "${S}"/unix && ECONF_SOURCE=".." econf ${myeconfargs} \
		--disable-tdomalloc --with-expat
	cd "${S}"/extensions/tdomhtml && econf
	cd "${S}"/extensions/tnc && econf ${myeconfargs}
}

src_compile() {
	local dir

	for dir in "${S}"/unix "${S}"/extensions/tnc; do
		pushd ${dir} > /dev/null
			emake
		popd > /dev/null
	done
}

src_test() {
	cd unix && default
}

src_install() {
	local dir

	dodoc CHANGES ChangeLog README*

	for dir in "${S}"/unix "${S}"/extensions/tdomhtml "${S}"/extensions/tnc; do
		pushd ${dir} > /dev/null
			emake DESTDIR="${D}" install
		popd > /dev/null
	done
}
