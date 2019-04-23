# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils toolchain-funcs multilib flag-o-matic

MY_P="js-${PV}"
DESCRIPTION="Stand-alone JavaScript C library"
HOMEPAGE="https://developer.mozilla.org/en-US/docs/Mozilla/Projects/SpiderMonkey"
SRC_URI="http://archive.mozilla.org/pub/js/${MY_P}.tar.gz
	https://dev.gentoo.org/~axs/distfiles/${PN}-slot0-patches-01.tar.xz
	"

LICENSE="NPL-1.1"
SLOT="0/js"
KEYWORDS="alpha amd64 ~arm ppc ppc64 ~sparc x86 ~x86-fbsd"
IUSE="threadsafe unicode"

S="${WORKDIR}/js/src"

RDEPEND="threadsafe? ( dev-libs/nspr )"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${WORKDIR}"/sm0/${PN}-1.5-build.patch \
		"${WORKDIR}"/sm0/${PN}-1.6-header.patch \
		"${WORKDIR}"/sm0/${P}-threadsafe.diff \
		"${WORKDIR}"/sm0/${P}-ldflags.patch

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
