# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{5,6} )
DISTUTILS_OPTIONAL=1

inherit distutils-r1 flag-o-matic toolchain-funcs

# should match pinned git submodule version of third_party/protobuf
# look it up here https://github.com/grpc/grpc/tree/v"${PV}"/third_party
# also should ~depend on same version of dev-libs/protobuf below
PROTOBUF_VERSION="3.5.2"

DESCRIPTION="Modern open source high performance RPC framework"
HOMEPAGE="https://www.grpc.io"
SRC_URI="
	https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	tools? ( https://github.com/google/protobuf/archive/v${PROTOBUF_VERSION}.tar.gz -> protobuf-${PROTOBUF_VERSION}.tar.gz )
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples doc python systemtap static-libs tools"

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	tools? ( python )
"

RDEPEND="
	>=dev-libs/openssl-1.0.2:0=[-bindist]
	>=dev-libs/protobuf-${PROTOBUF_VERSION}:=
	dev-util/google-perftools
	net-dns/c-ares:=
	sys-libs/zlib:=
	python? ( ${PYTHON_DEPS}
		dev-python/cython[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
		virtual/python-enum34[${PYTHON_USEDEP}]
		virtual/python-futures[${PYTHON_USEDEP}]
		tools? ( >=dev-python/protobuf-python-3.5.1:=[${PYTHON_USEDEP}] )
	)
	systemtap? ( dev-util/systemtap )
"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? (
		python? (
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]
		)
	)
"

PATCHES=(
	"${FILESDIR}/0001-grpc-1.13.0-fix-host-ar-handling.patch"
	"${FILESDIR}/0002-grpc-1.3.0-Fix-unsecure-.pc-files.patch"
	"${FILESDIR}/0003-grpc-1.3.0-Don-t-run-ldconfig.patch"
	"${FILESDIR}/0004-grpc-1.11.0-fix-cpp-so-version.patch"
	"${FILESDIR}/0005-grpc-1.11.0-pkgconfig-libdir.patch"
	"${FILESDIR}/0009-grpc-1.12.1-gcc8-fixes.patch"
)

src_prepare() {
	sed -i 's@$(prefix)/lib@$(prefix)/$(INSTALL_LIBDIR)@g' Makefile || die "fix libdir"
	default
	use python && distutils-r1_src_prepare
}

python_prepare() {
	if use tools; then
		rm -r third_party/protobuf || die "removing empty protobuf dir failed"
		ln -s "${S}"/../protobuf-"${PROTOBUF_VERSION}" third_party/protobuf || die
		pushd tools/distrib/python/grpcio_tools >/dev/null || die
		# absolute symlinks will fail
		# ./src -> ${S}/src
		ln -s ../../../../src ./ || die
		# ./third_party -> ${S}/third_party
		ln -s ../../../../third_party ./ || die
		# ./grpc_root -> ${S}
		ln -s ../../../../ ./grpc_root || die
		# prevent above symlinks creating huge SOURCES.TXT files, bug #661244
		echo "prune grpc_root/tools/distrib/python/grpcio_tools" >> MANIFEST.in
		popd >/dev/null || die
	fi
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
		HAS_SYSTEMTAP="$(usex systemtap true false)"

	use python && distutils-r1_src_compile
}

python_compile() {
	export GRPC_PYTHON_BUILD_SYSTEM_CARES=1
	export GRPC_PYTHON_BUILD_SYSTEM_OPENSSL=1
	export GRPC_PYTHON_BUILD_SYSTEM_ZLIB=1
	export GRPC_PYTHON_BUILD_WITH_CYTHON=1
	distutils-r1_python_compile

	if use tools; then
		pushd tools/distrib/python/grpcio_tools >/dev/null || die
		distutils-r1_python_compile
		popd >/dev/null || die
	fi
}

python_compile_all() {
	if use doc; then
		esetup.py doc
		mv doc/build doc/html || die
	fi
}

src_install() {
	emake \
		prefix="${ED%/}"/usr \
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
		local DOCS=( AUTHORS README.md doc/. )
	fi

	einstalldocs

	use python && distutils-r1_src_install

}

python_install() {
	distutils-r1_python_install

	if use tools; then
		pushd tools/distrib/python/grpcio_tools >/dev/null || die
		distutils-r1_python_install
		popd >/dev/null || die
	fi
}
