# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/mono/mono-3.2.3.ebuild,v 1.3 2014/11/18 02:45:27 zerochaos Exp $

EAPI="5"
AUTOTOOLS_PRUNE_LIBTOOL_FILES="all"

inherit eutils linux-info mono-env flag-o-matic pax-utils autotools-utils

DESCRIPTION="Mono runtime and class libraries, a C# compiler/interpreter"
HOMEPAGE="http://www.mono-project.com/Main_Page"
SRC_URI="http://download.mono-project.com/sources/${PN}/${P}.tar.bz2"

LICENSE="MIT LGPL-2.1 GPL-2 BSD-4 NPL-1.1 Ms-PL GPL-2-with-linking-exception IDPL"
SLOT="0"

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux"

IUSE="nls minimal pax_kernel xen doc debug"

COMMONDEPEND="
	!dev-util/monodoc
	!minimal? ( >=dev-dotnet/libgdiplus-2.10 )
	ia64? (	sys-libs/libunwind )
	nls? ( sys-devel/gettext )
"
RDEPEND="${COMMONDEPEND}
	|| ( www-client/links www-client/lynx )
"
DEPEND="${COMMONDEPEND}
	sys-devel/bc
	virtual/yacc
	pax_kernel? ( sys-apps/elfix )
"

pkg_pretend() {
	# If CONFIG_SYSVIPC is not set in your kernel .config, mono will hang while compiling.
	# See http://bugs.gentoo.org/261869 for more info."
	CONFIG_CHECK="~SYSVIPC"
	use kernel_linux && check_extra_config
}

pkg_setup() {
	linux-info_pkg_setup
	mono-env_pkg_setup
}

src_prepare() {
	# we need to sed in the paxctl-ng -mr in the runtime/mono-wrapper.in so it don't
	# get killed in the build proces when MPROTEC is enable. #286280
	# RANDMMAP kill the build proces to #347365
	if use pax_kernel ; then
		ewarn "We are disabling MPROTECT on the mono binary."

		# issue 9 : https://github.com/Heather/gentoo-dotnet/issues/9
		sed '/exec "/ i\paxctl-ng -mr "$r/@mono_runtime@"' -i "${S}"/runtime/mono-wrapper.in || die "Failed to sed mono-wrapper.in"
	fi

	# mono build system can fail otherwise
	strip-flags

	# Remove this at your own peril. Mono will barf in unexpected ways.
	append-flags -fno-strict-aliasing

	autotools-utils_src_prepare
}

src_configure() {
	# NOTE: We need the static libs for now so mono-debugger works.
	# See http://bugs.gentoo.org/show_bug.cgi?id=256264 for details
	#
	# --without-moonlight since www-plugins/moonlight is not the only one
	# using mono: https://bugzilla.novell.com/show_bug.cgi?id=641005#c3
	#
	# --with-profile4 needs to be always enabled since it's used by default
	# and, otherwise, problems like bug #340641 appear.
	#
	# sgen fails on ppc, bug #359515
	local myeconfargs=(
		--enable-system-aot=yes
		--enable-static
		--disable-quiet-build
		--without-moonlight
		--with-libgdiplus=$(usex minimal no installed)
		$(use_with xen xen_opt)
		--without-ikvm-native
		--with-jit
		--disable-dtrace
		--with-profile4
		--with-sgen=$(usex ppc no yes)
		$(use_with doc mcs-docs)
		$(use_enable debug)
		$(use_enable nls)
	)

	autotools-utils_src_configure
}

src_compile() {
	nonfatal autotools-utils_src_compile || {
		eqawarn "maintainer of this ebuild has no idea why it fails. If you happen to know how to fix it - please let me know"
		autotools-utils_src_compile
	 }
}

src_test() {
	cd mcs/tests || die
	emake check
}

src_install() {
	autotools-utils_src_install

	# Remove files not respecting LDFLAGS and that we are not supposed to provide, see Fedora
	# mono.spec and http://www.mail-archive.com/mono-devel-list@lists.ximian.com/msg24870.html
	# for reference.
	rm -f "${ED}"/usr/lib/mono/{2.0,4.5}/mscorlib.dll.so || die
	rm -f "${ED}"/usr/lib/mono/{2.0,4.5}/mcs.exe.so || die
}
