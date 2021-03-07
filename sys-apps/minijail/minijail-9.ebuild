# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info toolchain-funcs

DESCRIPTION="helper binary and library for sandboxing & restricting privs of service"
HOMEPAGE="https://android.googlesource.com/platform/external/minijail"

# Use GitHub mirror as Gitiles doesn't generate stable tarballs.
SRC_URI="https://github.com/google/${PN}/archive/linux-v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+seccomp test"
RESTRICT="!test? ( test )"

RDEPEND="sys-libs/libcap-ng:="
DEPEND="${RDEPEND}
	test? (
		virtual/pkgconfig
		>=dev-cpp/gtest-1.8.0:=
	)"

S="${WORKDIR}/${PN}-linux-v${PV}"

PATCHES=(
	"${FILESDIR}/minijail-9-makefile.patch"
)

pkg_pretend() {
	local CONFIG_CHECK="~NAMESPACES ~UTS_NS ~IPC_NS ~USER_NS ~PID_NS ~NET_NS
		~SECCOMP ~SECCOMP_FILTER ~CGROUPS"
	check_extra_config
}

src_configure() {
	export LIBDIR="/usr/$(get_libdir)"
	export USE_seccomp="$(usex seccomp)"
	export USE_SYSTEM_GTEST=yes
	export GTEST_CXXFLAGS="$(pkg-config --cflags gtest_main)"
	export GTEST_LIBS="$(pkg-config --libs gtest_main)"
}

src_compile() {
	tc-env_build emake VERBOSE=1 all parse_seccomp_policy
}

src_test() {
	GTEST_FILTER="-NamespaceTest.test_tmpfs_userns:NamespaceTest.test_namespaces" \
		tc-env_build emake VERBOSE=1 tests
}

src_install() {
	dosbin minijail0
	dolib.so libminijail{,preload}.so
	dobin parse_seccomp_policy

	doman minijail0.[15]

	local include_dir="/usr/include"

	"${S}"/platform2_preinstall.sh "${PV}" "${include_dir}"
	insinto "/usr/$(get_libdir)/pkgconfig"
	doins libminijail.pc

	insinto "${include_dir}"
	doins libminijail.h
	doins scoped_minijail.h
}
