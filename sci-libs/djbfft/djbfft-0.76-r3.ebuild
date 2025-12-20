# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs multilib multilib-minimal

DESCRIPTION="Extremely fast library for floating-point convolution"
HOMEPAGE="https://cr.yp.to/djbfft.html"
SRC_URI="https://cr.yp.to/djbfft/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~ppc ppc64 ~riscv ~sparc ~x86"

PATCHES=(
	"${FILESDIR}"/${P}-gcc3.patch
	"${FILESDIR}"/${P}-shared.patch
	"${FILESDIR}"/${P}-headers.patch
	"${FILESDIR}"/${P}-tc-directly.patch
)

DOCS=( CHANGES README TODO VERSION )

src_prepare() {
	default

	# mask out everything which is not suggested by the author (RTFM)!
	ALLOWED_FLAGS="-fstack-protector -march -mcpu -pipe -mpreferred-stack-boundary -ffast-math"
	strip-flags

	SOVER="${PV:0:1}.${PV:2:1}.${PV:3:1}" # a.bc -> a.b.c
	SONAME="libdjbfft.so.${SOVER}"

	multilib_copy_sources
}

multilib_src_configure() {
	tc-export AR RANLIB
	[[ ${ABI} == x86* ]] && append-cflags -malign-double

	sed -i -e "s:\"lib\":\"$(get_libdir)\":" hier.c || die
	echo "$(tc-getCC) ${CFLAGS} -fPIC" > "conf-cc"
	echo "$(tc-getCC) ${LDFLAGS}" > "conf-ld"
	echo "${ED}/usr" > "conf-home"
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
