# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils toolchain-funcs multilib flag-o-matic

MY_P="js-${PV}"
DESCRIPTION="Stand-alone JavaScript C library"
HOMEPAGE="http://www.mozilla.org/js/spidermonkey/"
SRC_URI="ftp://ftp.mozilla.org/pub/mozilla.org/js/${MY_P}.tar.gz"

LICENSE="NPL-1.1"
SLOT="0/js"
KEYWORDS="alpha amd64 ~arm ppc ~ppc64 sparc x86 ~x86-fbsd"
IUSE="threadsafe unicode"

S="${WORKDIR}/js/src"

RDEPEND="threadsafe? ( dev-libs/nspr )"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.5-build.patch"
	epatch "${FILESDIR}/${PN}-1.6-header.patch"
	epatch "${FILESDIR}/${P}-threadsafe.diff" \
		"${FILESDIR}"/${P}-ldflags.patch

	# don't force owner for Prefix
	sed -i -e '/^INSTALL :=/s/-g 0 -o root//' Makefile.ref || die

	if [[ ${CHOST} == *-freebsd* ]]; then
		# Don't try to be smart, this does not work in cross-compile anyway
		ln -s "${S}/config/Linux_All.mk" "${S}/config/$(uname -s)$(uname -r).mk"
	fi
}

src_compile() {
	use unicode && append-flags "-DJS_C_STRINGS_ARE_UTF8"
	tc-export CC LD AR RANLIB
	local threadsafe=""
	use threadsafe && threadsafe="JS_THREADSAFE=1"
	emake -j1 -f Makefile.ref LIBDIR="$(get_libdir)" ${threadsafe} \
		XLDFLAGS="$(raw-ldflags)" HOST_LDFLAGS="${LDFLAGS}"
}

src_install() {
	emake -f Makefile.ref install DESTDIR="${ED}" LIBDIR="$(get_libdir)"
	dodoc ../jsd/README
	dohtml README.html
}
