# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{5,6} )
inherit python-r1 toolchain-funcs multilib flag-o-matic

DESCRIPTION="Modern open source high performance RPC framework"
HOMEPAGE="https://www.grpc.io"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	>=dev-libs/openssl-1.0.2:0=[-bindist]
	>=dev-libs/protobuf-3:=
	net-dns/c-ares:=
	sys-libs/zlib:="

DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/0001-grpc-1.11.0-Fix-cross-compiling.patch"
	"${FILESDIR}/0002-grpc-1.3.0-Fix-unsecure-.pc-files.patch"
	"${FILESDIR}/0003-grpc-1.3.0-Don-t-run-ldconfig.patch"
	"${FILESDIR}/0004-grpc-1.11.0-fix-cpp-so-version.patch"
	"${FILESDIR}/0005-grpc-1.11.0-pkgconfig-libdir.patch"
)

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
		LD="${CC}" \
		LDXX="${CXX}" \
		STRIP=true \
		HOST_CC="$(tc-getBUILD_CC)" \
		HOST_CXX="$(tc-getBUILD_CXX)" \
		HOST_LD="$(tc-getBUILD_CC)" \
		HOST_LDXX="$(tc-getBUILD_CXX)" \
		HOST_AR="$(tc-getBUILD_AR)"
}

src_install() {
	emake \
		prefix="${ED%/}"/usr \
		INSTALL_LIBDIR="$(get_libdir)" \
		STRIP=true \
		install
}
