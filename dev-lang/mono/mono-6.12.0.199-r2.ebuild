# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CHECKREQS_DISK_BUILD="4500M"
inherit autotools check-reqs flag-o-matic linux-info mono-env pax-utils multilib-minimal

DESCRIPTION="Mono runtime and class libraries, a C# compiler/interpreter"
HOMEPAGE="https://mono-project.com"
SRC_URI="https://download.mono-project.com/sources/mono/${P}.tar.xz"

LICENSE="MIT LGPL-2.1 GPL-2 BSD-4 NPL-1.1 Ms-PL GPL-2-with-linking-exception IDPL"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 -riscv x86 ~amd64-linux"
IUSE="doc minimal nls pax-kernel selinux xen"

# Note: mono works incorrect with older versions of libgdiplus
# Details on dotnet overlay issue: https://github.com/gentoo/dotnet/issues/429
DEPEND="
	app-crypt/mit-krb5[${MULTILIB_USEDEP}]
	sys-libs/zlib[${MULTILIB_USEDEP}]
	!minimal? ( >=dev-dotnet/libgdiplus-6.0.2 )
	nls? ( sys-devel/gettext )
"
RDEPEND="
	${DEPEND}
	app-misc/ca-certificates
	selinux? ( sec-policy/selinux-mono )
"
# CMake is used for bundled deps
BDEPEND="
	dev-build/cmake
	app-alternatives/bc
	app-alternatives/yacc
	pax-kernel? ( sys-apps/elfix )
"

PATCHES=(
	"${FILESDIR}"/${PN}-5.12-try-catch.patch
	"${FILESDIR}"/${PN}-6.12.0.122-disable-automagic-ccache.patch
	"${FILESDIR}"/${PN}-6.12.0.199-configure-c99.patch
)

pkg_pretend() {
	linux-info_pkg_setup

	if use kernel_linux ; then
		if linux_config_exists ; then
			linux_chkconfig_builtin SYSVIPC || die "SYSVIPC not enabled in the kernel"
		else
			# https://github.com/gentoo/gentoo/blob/f200e625bda8de696a28338318c9005b69e34710/eclass/linux-info.eclass#L686
			ewarn "kernel config not found"
			ewarn "If CONFIG_SYSVIPC is not set in your kernel .config, mono will hang while compiling."
			ewarn "See https://bugs.gentoo.org/261869 for more info."
		fi
	fi

	# bug #687892
	check-reqs_pkg_pretend
}

pkg_setup() {
	mono-env_pkg_setup
	check-reqs_pkg_setup
}

src_prepare() {
	# We need to sed in the paxctl-ng -mr in the runtime/mono-wrapper.in so it don't
	# get killed in the build proces when MPROTECT is enabled, bug #286280
	# RANDMMAP kills the build process too, bug #347365
	# We use paxmark.sh to get PT/XT logic, bug #532244
	if use pax-kernel ; then
		ewarn "We are disabling MPROTECT on the mono binary."

		# issue 9 : https://github.com/Heather/gentoo-dotnet/issues/9
		sed '/exec "/ i\paxmark.sh -mr "$r/@mono_runtime@"' -i "${S}"/runtime/mono-wrapper.in || die "Failed to sed mono-wrapper.in"
	fi

	default

	# PATCHES contains configure.ac patch
	eautoreconf
	multilib_copy_sources
}

multilib_src_configure() {
	# Many, many unsafe warnings. Miscompiled with -O3 too: bug #915985.
	append-flags -O2 -fno-strict-aliasing
	filter-lto

	local myeconfargs=(
		$(use_with xen xen_opt)
		--without-ikvm-native
		--disable-dtrace
		--enable-system-aot
		$(multilib_native_use_with doc mcs-docs)
		$(use_enable nls)
	)

	# Workaround(?) for bug #779025
	# May be able to do a real fix by adjusting path used?
	if multilib_is_native_abi ; then
		myeconfargs+=( --enable-system-aot )
	else
		myeconfargs+=( --disable-system-aot )
	fi

	econf "${myeconfargs[@]}"
}

multilib_src_test() {
	emake -C mcs/tests check
}

multilib_src_install() {
	default

	# Remove files not respecting LDFLAGS and that we are not supposed to provide, see Fedora
	# mono.spec and http://www.mail-archive.com/mono-devel-list@lists.ximian.com/msg24870.html
	# for reference.
	rm -f "${ED}"/usr/lib/mono/{2.0,4.5}/mscorlib.dll.so || die
	rm -f "${ED}"/usr/lib/mono/{2.0,4.5}/mcs.exe.so || die
}

pkg_postinst() {
	# bug #762265
	cert-sync "${EROOT}"/etc/ssl/certs/ca-certificates.crt
}
