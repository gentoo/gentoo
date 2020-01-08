# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib-minimal

DESCRIPTION="GNU VCDimager"
HOMEPAGE="http://www.vcdimager.org/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 ~sh sparc x86"
IUSE="+xml static-libs"

RDEPEND="
	>=dev-libs/libcdio-0.90-r1:0=[-minimal,${MULTILIB_USEDEP}]
	<dev-libs/libcdio-1.0
	dev-libs/popt
	xml? ( dev-libs/libxml2:2 )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

DOCS=( AUTHORS BUGS ChangeLog FAQ HACKING NEWS README THANKS TODO )

PATCHES=( "${FILESDIR}/${P}-libcdio-1.0.0.patch" )

src_prepare() {
	default

	# Avoid building useless programs. Bug #226249
	sed -i \
		-e 's/check_PROGRAMS =/check_PROGRAMS +=/' \
		-e 's/noinst_PROGRAMS =/check_PROGRAMS =/' \
		test/Makefile.in || die
	sed -i \
		-e 's/noinst_PROGRAMS =/check_PROGRAMS =/' \
		example/Makefile.in || die
}

multilib_src_configure() {
	# We disable the xmltest because the configure script includes differently
	# than the actual XML-frontend C files.
	local myconf
	if use xml && multilib_is_native_abi ; then
		myconf="--with-xml-prefix=${EPREFIX}/usr --disable-xmltest"
	else
		myconf="--without-xml-frontend"
	fi
	multilib_is_native_abi || myconf="${myconf} --without-cli-frontend"
	ECONF_SOURCE="${S}" \
		econf $(use_enable static-libs static) ${myconf}
}

multilib_src_install_all() {
	find "${D}" -name '*.la' -delete
	einstalldocs
}
