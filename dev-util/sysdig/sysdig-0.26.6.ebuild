# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 cmake

DESCRIPTION="A system exploration and troubleshooting tool"
HOMEPAGE="https://sysdig.com/"
SRC_URI="https://github.com/draios/sysdig/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libressl +modules test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-misc/jq:0=
	dev-cpp/tbb:0=
	dev-lang/luajit:2=
	>=dev-libs/jsoncpp-0.6_pre:0=
	dev-libs/libb64:0=
	dev-libs/protobuf:0=
	net-dns/c-ares:0=
	net-libs/grpc:0=
	sys-libs/ncurses:0=
	sys-libs/zlib:0=
	libressl? ( dev-libs/libressl:0= )
	!libressl? ( dev-libs/openssl:0= )
	net-misc/curl:0="
DEPEND="${RDEPEND}
	virtual/os-headers
	test? ( dev-cpp/gtest )"
PDEPEND="
	modules? ( >=dev-util/sysdig-kmod-${PV} )"

src_prepare() {
	sed -i -e 's:-ggdb::' CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCREATE_TEST_TARGETS=$(usex test)

		# done in dev-util/sysdig-kmod
		-DBUILD_DRIVER=OFF
		# libscap examples are not installed or really useful
		-DBUILD_LIBSCAP_EXAMPLES=OFF

		# unbundle the deps
		-DUSE_BUNDLED_DEPS=OFF
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	# remove sources
	rm -r "${ED}"/usr/src || die

	# move bashcomp to the proper location
	dobashcomp "${ED}"/usr/etc/bash_completion.d/sysdig || die
	rm -r "${ED}"/usr/etc || die
}
