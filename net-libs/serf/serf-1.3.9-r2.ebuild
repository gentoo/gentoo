# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_6 python3_7 python3_8 python3_9 )

inherit python-any-r1 scons-utils toolchain-funcs flag-o-matic

DESCRIPTION="HTTP client library"
HOMEPAGE="https://serf.apache.org/"
SRC_URI="mirror://apache/${PN}/${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="1"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="kerberos static-libs libressl"
RESTRICT="test"

RDEPEND="dev-libs/apr:1=
	dev-libs/apr-util:1=
	!libressl? ( dev-libs/openssl:0= ) libressl? ( dev-libs/libressl:0= )
	sys-libs/zlib:0=
	kerberos? ( virtual/krb5 )"
DEPEND="${RDEPEND}
	>=dev-util/scons-2.3.0"

PATCHES=( "${FILESDIR}"/${PN}-1.3.8-static-lib.patch
	"${FILESDIR}"/${PN}-1.3.8-openssl.patch
	"${FILESDIR}"/${PN}-1.3.9-python3.patch
	"${FILESDIR}"/${PN}-1.3.9-python3_byte.patch
	"${FILESDIR}"/${PN}-1.3.9-python3-check.patch
	"${FILESDIR}"/${PN}-1.3.9-libressl.patch )

src_prepare() {
	default

	# https://code.google.com/p/serf/issues/detail?id=133
	sed -e "/env.Append(CCFLAGS=\['-O2'\])/d" -i SConstruct

	# need limits.h for PATH_MAX (only when EXTENSIONS is enabled)
	[[ ${CHOST} == *-solaris* ]] && append-cppflags -D__EXTENSIONS__
}

src_compile() {
	myesconsargs=(
		PREFIX="${EPREFIX}/usr"
		LIBDIR="${EPREFIX}/usr/$(get_libdir)"
		# These config scripts are sent through a shell with an empty env
		# which breaks the SYSROOT usage in them.  Set the vars inline to
		# avoid that.
		APR="SYSROOT='${SYSROOT}' ${SYSROOT}${EPREFIX}/usr/bin/apr-1-config"
		APU="SYSROOT='${SYSROOT}' ${SYSROOT}${EPREFIX}/usr/bin/apu-1-config"
		BUILD_STATIC=$(usex static-libs)
		AR="$(tc-getAR)"
		RANLIB="$(tc-getRANLIB)"
		CC="$(tc-getCC)"
		CPPFLAGS="${CPPFLAGS}"
		CFLAGS="${CFLAGS}"
		LINKFLAGS="${LDFLAGS}"
	)

	if use kerberos; then
		myesconsargs+=( GSSAPI="${SYSROOT}${EPREFIX}/usr/bin/krb5-config" )
	fi

	escons "${myesconsargs[@]}"
}

src_test() {
	escons check
}

src_install() {
	escons install --install-sandbox="${D}"
}
