# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
GCONF_DEBUG="yes"
GNOME_ORG_MODULE="ORBit2"
GNOME_TARBALL_SUFFIX="bz2"
GNOME2_LA_PUNT="yes"

inherit eutils gnome2 toolchain-funcs autotools multilib-minimal

DESCRIPTION="ORBit2 is a high-performance CORBA ORB"
HOMEPAGE="https://projects.gnome.org/ORBit2/"

LICENSE="GPL-2 LGPL-2"
SLOT="2"
KEYWORDS="alpha amd64 arm ~arm64 ia64 ~mips ppc ppc64 ~sh sparc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE="pic static-libs test"
RESTRICT="!test? ( test )"
REQUIRED_USE="test? ( debug )"

RDEPEND=">=dev-libs/glib-2.44.1-r1:2[${MULTILIB_USEDEP}]
	>=dev-libs/libIDL-0.8.14-r1[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	virtual/pkgconfig
"

DOCS="AUTHORS ChangeLog HACKING MAINTAINERS NEWS README* TODO"

MULTILIB_WRAPPED_HEADERS=( /usr/include/orbit-2.0/orbit/orbit-config.h )

MULTILIB_CHOST_TOOLS=( /usr/bin/orbit2-config )

src_prepare() {
	# Fix wrong process kill, bug #268142
	sed "s:killall lt-timeout-server:killall timeout-server:" \
		-i test/timeout.sh || die "sed 1 failed"

	# Do not mess with CFLAGS
	sed 's/-ggdb -O0//' -i configure.in configure || die "sed 2 failed"

	if ! use test; then
		sed -i -e 's/test //' Makefile.am || die
	fi

	# Drop failing test, bug #331709
	sed -i -e 's/test-mem //' test/Makefile.am || die

	# Fix link_protocol_is_local() for ipv4 on machines with ipv6
	# https://bugzilla.gnome.org/show_bug.cgi?id=693636
	epatch "${FILESDIR}/${PN}-2.14.19-link_protocol_is_local.patch"

	# Build libname-server-2.a with -fPIC on hardened, bug #312161
	epatch "${FILESDIR}/${PN}-2.14.19-fPIC.patch"

	epatch "${FILESDIR}"/${P}-automake-1.13.patch
	epatch "${FILESDIR}"/${P}-parallel-build.patch #273031
	epatch "${FILESDIR}"/${P}-aix-func_data.patch #515094

	eautoreconf
	gnome2_src_prepare

	# we have to copy sources, there is something that causes tests
	# to segfault when libs are out-of-source built.
	multilib_copy_sources
}

multilib_src_configure() {
	local myconf=()

	# We need to unset IDL_DIR, which is set by RSI's IDL.  This causes certain
	# files to be not found by autotools when compiling ORBit.  See bug #58540
	# for more information.  Please don't remove -- 8/18/06
	unset IDL_DIR

	# We need to use the hosts IDL compiler if cross-compiling, bug #262741
	if tc-is-cross-compiler; then
		# check that host version is present and executable
		[[ -x ${EPREFIX}/usr/bin/orbit-idl-2 ]] || die "Please emerge ~${CATEGORY}/${P} on the host system first"
		myconf=("${myconf[@]}" "--with-idl-compiler=${EPREFIX}/usr/bin/orbit-idl-2")
	fi
	gnome2_src_configure \
		$(use_enable pic libname-server-pic) \
		$(use_enable static-libs static) \
		"${myconf[@]}"
}

multilib_src_compile() {
	# Parallel compilation fails, bug #635094
	MAKEOPTS="${MAKEOPTS} -j1" gnome2_src_compile
}

multilib_src_install() {
	gnome2_src_install
}

multilib_src_test() {
	# can fail in parallel, see bug #235994
	emake -j1 check
}
