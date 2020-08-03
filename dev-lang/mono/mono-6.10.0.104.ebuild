# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux"

SLOT="0"

IUSE="nls minimal pax_kernel xen doc"

inherit autotools eutils linux-info mono-env flag-o-matic pax-utils multilib-minimal

DESCRIPTION="Mono runtime and class libraries, a C# compiler/interpreter"
HOMEPAGE="https://mono-project.com"
LICENSE="MIT LGPL-2.1 GPL-2 BSD-4 NPL-1.1 Ms-PL GPL-2-with-linking-exception IDPL"

SRC_URI="https://download.mono-project.com/sources/mono/${P}.tar.xz"

#Note: mono works incorrect with older versions of libgdiplus
#details on dotnet overlay issue: https://github.com/gentoo/dotnet/issues/429
COMMONDEPEND="
	!minimal? ( >=dev-dotnet/libgdiplus-6.0.2 )
	ia64? ( sys-libs/libunwind )
	nls? ( sys-devel/gettext )
"
RDEPEND="${COMMONDEPEND}"
DEPEND="${COMMONDEPEND}
	sys-devel/bc
	virtual/yacc
	pax_kernel? ( sys-apps/elfix )
	dev-util/cmake
"

PATCHES=(
	"${FILESDIR}"/mono-5.12-try-catch.patch
)

pkg_pretend() {
	linux-info_pkg_setup
	if use kernel_linux; then
		if linux_config_exists; then
			linux_chkconfig_builtin SYSVIPC || die "SYSVIPC not enabled in the kernel"
		else
			# https://github.com/gentoo/gentoo/blob/f200e625bda8de696a28338318c9005b69e34710/eclass/linux-info.eclass#L686
			ewarn "kernel config not found"
			ewarn "If CONFIG_SYSVIPC is not set in your kernel .config, mono will hang while compiling."
			ewarn "See https://bugs.gentoo.org/261869 for more info."
		fi
	fi
}

pkg_setup() {
	mono-env_pkg_setup
}

src_prepare() {
	# we need to sed in the paxctl-ng -mr in the runtime/mono-wrapper.in so it don't
	# get killed in the build proces when MPROTECT is enable. #286280
	# RANDMMAP kill the build proces to #347365
	# use paxmark.sh to get PT/XT logic #532244
	if use pax_kernel ; then
		ewarn "We are disabling MPROTECT on the mono binary."

		# issue 9 : https://github.com/Heather/gentoo-dotnet/issues/9
		sed '/exec "/ i\paxmark.sh -mr "$r/@mono_runtime@"' -i "${S}"/runtime/mono-wrapper.in || die "Failed to sed mono-wrapper.in"
	fi

	# mono build system can fail otherwise
	strip-flags

	default

	# PATCHES contains configure.ac patch
	eautoreconf
	multilib_copy_sources
}

multilib_src_configure() {
	local myeconfargs=(
		$(use_with xen xen_opt)
		--without-ikvm-native
		--disable-dtrace
		--enable-system-aot
		$(use_with doc mcs-docs)
		$(use_enable nls)
	)

	econf "${myeconfargs[@]}"
}

multilib_src_test() {
	cd mcs/tests || die
	emake check
}

multilib_src_install() {
	default_src_install

	# Remove files not respecting LDFLAGS and that we are not supposed to provide, see Fedora
	# mono.spec and http://www.mail-archive.com/mono-devel-list@lists.ximian.com/msg24870.html
	# for reference.
	rm -f "${ED}"/usr/lib/mono/{2.0,4.5}/mscorlib.dll.so || die
	rm -f "${ED}"/usr/lib/mono/{2.0,4.5}/mcs.exe.so || die
}
