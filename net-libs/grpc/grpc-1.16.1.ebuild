# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

MY_PV="${PV//_pre/-pre}"

DESCRIPTION="Modern open source high performance RPC framework"
HOMEPAGE="https://www.grpc.io"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples doc perftools systemtap static-libs"

RDEPEND="
	>=dev-libs/openssl-1.0.2:0=[-bindist]
	dev-libs/protobuf:=
	net-dns/c-ares:=
	sys-libs/zlib:=
	perftools? ( dev-util/google-perftools:= )
	systemtap? ( dev-util/systemtap )
"

DEPEND="${RDEPEND}
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/grpc-1.13.0-fix-host-ar-handling.patch"
	"${FILESDIR}/grpc-1.3.0-Don-t-run-ldconfig.patch"
	"${FILESDIR}/grpc-1.11.0-pkgconfig-libdir.patch"
	"${FILESDIR}/grpc-1.15.0-fix-cpp-so-version.patch"
	"${FILESDIR}/grpc-1.16.0-gcc8-fixes.patch"
	"${FILESDIR}/grpc-1.16.0-Prevent-shell-calls-longer-than-ARG_MAX.patch"
)

S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare() {
	sed -i 's@$(prefix)/lib@$(prefix)/$(INSTALL_LIBDIR)@g' Makefile || die "fix libdir"
	default
}

src_compile() {
	tc-export CC CXX PKG_CONFIG

	emake \
		V=1 \
		prefix=/usr \
		INSTALL_LIBDIR="$(get_libdir)" \
		AR="$(tc-getAR)" \
		AROPTS="rcs" \
		CFLAGS="${CFLAGS}" \
		CXXFLAGS="${CXXFLAGS}" \
		LD="${CC}" \
		LDXX="${CXX}" \
		STRIP=/bin/true \
		HOST_CC="$(tc-getBUILD_CC)" \
		HOST_CXX="$(tc-getBUILD_CXX)" \
		HOST_LD="$(tc-getBUILD_CC)" \
		HOST_LDXX="$(tc-getBUILD_CXX)" \
		HOST_AR="$(tc-getBUILD_AR)" \
		HAS_SYSTEMTAP="$(usex systemtap true false)" \
		HAS_SYSTEM_PERFTOOLS="$(usex perftools true false)"
}

src_install() {
	emake \
		prefix="${ED}"/usr \
		INSTALL_LIBDIR="$(get_libdir)" \
		STRIP=/bin/true \
		install

	use static-libs || find "${ED}" -name '*.a' -delete

	if use examples; then
		find examples -name '.gitignore' -delete || die
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi

	if use doc; then
		find doc -name '.gitignore' -delete || die
		local DOCS=( AUTHORS README.md TROUBLESHOOTING.md doc/. )
	fi

	einstalldocs
}

pkg_postinst() {
	local v
	for v in ${REPLACING_VERSIONS}; do
		if ver_test "${v}" -lt 1.16.0; then
			ewarn "python bindings and tools moved to separate independent packages"
			ewarn "check dev-python/grpcio and dev-python/grpcio-tools"
		fi
	done

}
