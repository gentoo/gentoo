# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils flag-o-matic toolchain-funcs multilib multilib-minimal

DESCRIPTION="Extremely fast library for floating-point convolution"
HOMEPAGE="http://cr.yp.to/djbfft.html"
SRC_URI="http://cr.yp.to/djbfft/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""
DOCS=( CHANGES README TODO VERSION )

src_prepare() {
	SOVER="${PV:0:1}.${PV:2:1}.${PV:3:1}" # a.bc -> a.b.c
	# mask out everything, which is not suggested by the author (RTFM)!
	ALLOWED_FLAGS="-fstack-protector -march -mcpu -pipe -mpreferred-stack-boundary -ffast-math"
	strip-flags

	SONAME="libdjbfft.so.${SOVER}"

	epatch \
		"${FILESDIR}"/${P}-gcc3.patch \
		"${FILESDIR}"/${P}-shared.patch \
		"${FILESDIR}"/${P}-headers.patch
	multilib_copy_sources
}

multilib_src_configure() {
	[[ ${ABI} == x86* ]] && append-cflags -malign-double

	sed -i -e "s:\"lib\":\"$(get_libdir)\":" hier.c || die
	echo "$(tc-getCC) ${CFLAGS} -fPIC" > "conf-cc"
	echo "$(tc-getCC) ${LDFLAGS}" > "conf-ld"
	echo "${ED}usr" > "conf-home"
	einfo "conf-cc: $(<conf-cc)"
}

multilib_src_compile() {
	emake \
		LIBDJBFFT=${SONAME} \
		LIBPERMS=0755 \
		${SONAME}
	echo "the compile function was:"
	cat ./compile
	echo "the conf-ld function was:"
	cat ./conf-ld
}

multilib_src_test() {
	local t
	for t in accuracy accuracy2 speed; do
		emake ${t}
		einfo "Testing ${t}"
		LD_LIBRARY_PATH=. ./${t} > ${t}.out || die "test ${t} failed"
	done
}

multilib_src_install() {
	emake LIBDJBFFT=${SONAME} install
	./install || die "install failed"
	dosym ${SONAME} /usr/$(get_libdir)/libdjbfft.so
	dosym ${SONAME} /usr/$(get_libdir)/libdjbfft.so.${SOVER%%.*}
}
