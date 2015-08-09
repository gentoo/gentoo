# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils flag-o-matic multilib toolchain-funcs

MY_P="tDOM-${PV}"

DESCRIPTION="A XML/DOM/XPath/XSLT Implementation for Tcl"
HOMEPAGE="http://tdom.github.com/"
#SRC_URI="http://cloud.github.com/downloads/tDOM/${PN}/${MY_P}.tgz"
SRC_URI="mirror://github/tDOM/${PN}/${MY_P}.tgz"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ppc x86 ~amd64-linux ~x86-linux"
IUSE="static-libs threads"

DEPEND="
	dev-lang/tcl:0=
	dev-libs/expat"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/"${PN}-0.8.2.patch
	"${FILESDIR}/"${P}-soname.patch
	"${FILESDIR}/"${P}-expat.patch
	"${FILESDIR}/"${PN}-0.8.2-tnc.patch
	"${FILESDIR}/"${P}-tcl8.6.patch
	)

src_prepare() {
	tc-export AR
	append-libs -lm
	sed \
		-e 's:-O2::g' \
		-e 's:-pipe::g' \
		-e 's:-fomit-frame-pointer::g' \
		-e '/SHLIB_LD_LIBS/s:\"$: ${TCL_LIB_FLAG}":g' \
		-i {.,extensions/tnc}/configure tclconfig/tcl.m4 || die
	epatch "${PATCHES[@]}"
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable threads)
		--enable-shared
		--disable-tdomalloc
		--with-expat
		--with-tcl="${EPREFIX}"/usr/$(get_libdir)
		)

	cd "${S}"/unix && ECONF_SOURCE=".." econf ${myeconfargs}
	cd "${S}"/extensions/tdomhtml &&	econf ${myeconfargs}
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

src_install() {
	local dir

	dodoc CHANGES ChangeLog README*

	for dir in "${S}"/unix "${S}"/extensions/tdomhtml "${S}"/extensions/tnc; do
		pushd ${dir} > /dev/null
			emake DESTDIR="${D}" install
		popd > /dev/null
	done

	if ! use static-libs; then
		einfo "Removing static libs ..."
		rm -f "${ED}"/usr/$(get_libdir)/*.{a,la} || die
	fi
}
