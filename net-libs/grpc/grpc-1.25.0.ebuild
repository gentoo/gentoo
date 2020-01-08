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
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="examples doc perftools systemtap static-libs"

DEPEND="
	>=dev-libs/openssl-1.0.2:0=[-bindist]
	>=dev-libs/protobuf-3.8.0:=
	>=net-dns/c-ares-1.15.0:=
	sys-libs/zlib:=
	perftools? ( dev-util/google-perftools:= )
	systemtap? ( dev-util/systemtap )
"

RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

# requires network
RESTRICT="test"

PATCHES=(
	"${FILESDIR}/grpc-1.21.0-fix-host-ar-handling.patch"
	"${FILESDIR}/grpc-1.3.0-Don-t-run-ldconfig.patch"
	"${FILESDIR}/grpc-1.25.0-pkgconfig-libdir.patch"
	"${FILESDIR}/grpc-1.22.0-cxx_arg_list_too_long_forloop.patch" # https://github.com/grpc/grpc/issues/14844
)

S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare() {
	rm -r third_party/cares || die
	sed -i 's:-Werror::g' Makefile || die
	sed -i 's@$(prefix)/lib@$(prefix)/$(INSTALL_LIBDIR)@g' Makefile || die "fix libdir"

	default
}

src_compile() {
	tc-export CC CXX PKG_CONFIG

	local myemakeargs=(
		V=1
		prefix=/usr
		INSTALL_LIBDIR="$(get_libdir)"
		AR="$(tc-getAR)"
		AROPTS="rcs"
		CFLAGS="${CFLAGS}"
		CXXFLAGS="${CXXFLAGS}"
		LD="${CC}"
		LDXX="${CXX}"
		STRIP=/bin/true
		HOST_AR="$(tc-getBUILD_AR)"
		HOST_CC="$(tc-getBUILD_CC)"
		HOST_CXX="$(tc-getBUILD_CXX)"
		HOST_LD="$(tc-getBUILD_CC)"
		HOST_LDXX="$(tc-getBUILD_CXX)"
		HAS_SYSTEM_PERFTOOLS="$(usex perftools true false)"
		HAS_SYSTEMTAP="$(usex systemtap true false)"
	)

	emake "${myemakeargs[@]}"
}

src_install() {
	local myemakeargs=(
		V=1
		prefix="${ED}"/usr
		INSTALL_LIBDIR="$(get_libdir)"
		STRIP=/bin/true
	)

	emake "${myemakeargs[@]}" install

	use static-libs || find "${ED}" -name '*.a' -delete

	if use examples; then
		find examples -name '.gitignore' -delete || die
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi

	if use doc; then
		find doc -name '.gitignore' -delete || die
		local DOCS=( AUTHORS CONCEPTS.md README.md TROUBLESHOOTING.md doc/. )
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
