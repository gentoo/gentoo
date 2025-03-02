# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
USE_RUBY=( ruby3{1..3} )
LUA_COMPAT=( lua5-{1..4} luajit )

inherit autotools bash-completion-r1 linux-info lua-single perl-functions\
		python-single-r1 ruby-single toolchain-funcs vala

MY_PV_1="$(ver_cut 1-2)"
MY_PV_2="$(ver_cut 2)"
[[ $(( ${MY_PV_2} % 2 )) -eq 0 ]] && SD="stable" || SD="development"

DESCRIPTION="Tools for accessing, inspecting, and modifying virtual machine (VM) disk images"
HOMEPAGE="https://libguestfs.org/"
SRC_URI="https://download.libguestfs.org/${MY_PV_1}-${SD}/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0/${MY_PV_1}"
if [[ ${SD} == "stable" ]] ; then
	KEYWORDS="~amd64 ~ppc64 ~x86"
fi

IUSE="doc erlang +fuse introspection libvirt lua +ocaml +perl python readline ruby selinux static-libs test vala"

REQUIRED_USE="
	lua? ( ${LUA_REQUIRED_USE} )
	python? ( ${PYTHON_REQUIRED_USE} )
	vala? ( introspection )
"

RESTRICT="!test? ( test )"

# Not part of the system profile, but dependenices of it with base USE flags
COMMON_DEPEND_DEFAULT="
	app-arch/xz-utils
	app-arch/zstd
	dev-libs/libpcre2:=
	dev-libs/libxml2
	net-libs/libtirpc:=
	sys-libs/libcap-ng
	sys-libs/ncurses:=
	sys-libs/readline:=
	virtual/acl
	virtual/libcrypt
"
# Won't compile without it
COMMON_DEPEND_EXPLICIT="
	app-admin/augeas
	app-alternatives/cpio
	app-emulation/qemu[qemu_softmmu_targets_x86_64,selinux?]
	app-misc/hivex[ocaml?]
	dev-libs/json-c:=
	|| (
		dev-libs/libisoburn
		app-cdr/cdrtools
	)
"
# "Automagic" dependencies
COMMON_DEPEND_IMPLICIT="
	dev-libs/libconfig:=
	media-gfx/icoutils
	media-libs/netpbm[png]
"
# Sum of the above + conditional dependencies
COMMON_DEPEND="
	${COMMON_DEPEND_DEFAULT}
	${COMMON_DEPEND_EXPLICIT}
	${COMMON_DEPEND_IMPLICIT}
	erlang? ( dev-lang/erlang )
	fuse? ( sys-fs/fuse:0 )
	introspection? (
		dev-libs/glib
		dev-libs/gobject-introspection
	)
	libvirt? ( app-emulation/libvirt[qemu] )
	perl? (
		dev-perl/libintl-perl
		virtual/perl-Getopt-Long
	)
	python? ( ${PYTHON_DEPS} )
	readline? ( sys-libs/readline )
	ruby? ( ${RUBY_DEPS} )
	selinux? ( sys-libs/libselinux )
	vala? ( $(vala_depend) )
"
# Some OCaml is always required
# Bug #729674
DEPEND="
	${COMMON_DEPEND}
	dev-lang/ocaml:=[ocamlopt]
	dev-ml/findlib[ocamlopt]
	dev-util/gperf
"
RDEPEND="
	${COMMON_DEPEND}
	app-emulation/libguestfs-appliance
"
BDEPEND="
	sys-devel/bison
	sys-devel/flex
	sys-devel/gettext
	virtual/pkgconfig
	doc? ( app-text/po4a )
	lua? ( ${LUA_DEPS} )
	perl? (
		dev-perl/Module-Build
		virtual/perl-ExtUtils-CBuilder
		virtual/perl-Pod-Simple
	)
	test? (
		introspection? ( dev-libs/gjs )
		ocaml? ( dev-ml/ounit2[ocamlopt] )
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-1.52.1-disable-obsolete-lvmetad-in-tests.patch"
)

src_prepare() {
	cat <<EOF > "${S}/m4/guestfs-bash-completion.m4" || die
dnl Unconditionally install Bash completion files
AC_MSG_CHECKING([for bash-completions directory])
AC_SUBST([BASH_COMPLETIONS_DIR],[$(get_bashcompdir)])
AC_MSG_RESULT([\$BASH_COMPLETIONS_DIR])
AM_CONDITIONAL([HAVE_BASH_COMPLETION],[/bin/true])
EOF

	default
	eautoreconf
}

pkg_setup() {
	CONFIG_CHECK="~KVM ~VIRTIO"
	[[ -n "${CONFIG_CHECK}" ]] && check_extra_config

	use lua && lua-single_pkg_setup
	use python && python-single-r1_pkg_setup
}

src_configure() {
	# Bug #794877
	tc-export AR

	# m4/guestfs-progs.m4: (f)lex and bison for virt-builder (required).
	# Bug #915339
	unset LEX YACC

	local myconf=(
		--disable-appliance
		--disable-daemon
		--disable-haskell
		--disable-golang
		--disable-rust
		$(use_enable ocaml)
		--disable-php
		--without-java
		$(use_enable lua)
		$(use_enable erlang)
		$(use_enable vala)
		$(usex doc '' PO4A=no)
		--with-extra="-gentoo"
		$(use_with readline)
		$(use_enable ruby)
		$(use_enable fuse)
		$(use_enable introspection gobject)
		$(use_enable introspection)
		$(use_with libvirt)
		--with-default-backend=$(usex libvirt libvirt direct)
		$(use_enable perl)
		$(use_enable python)
		$(use_enable static-libs static)
	)

	# Avoid automagic SELinux dependency
	local -x ac_cv_header_selinux_selinux_h

	if use selinux &&  use !libvirt; then
		ewarn "USE=selinux has no effect without USE=libvirt"
		ac_cv_header_selinux_selinux_h="no"
	else
		ac_cv_header_selinux_selinux_h=$(usex selinux)
	fi

	use vala && vala_setup

	econf "${myconf[@]}"
}

src_install() {
	emake INSTALLDIRS=vendor DESTDIR="${D}" install "LINGUAS=""${LINGUAS}"""

	find "${ED}" -name '*.la' -delete || die

	use perl && perl_delete_localpod
	use python && python_optimize
}

src_test() {
	# app-shells/bash-completion may not be installed
	# Bug #794874
	local -x SKIP_TEST_COMPLETE_IN_SCRIPT_SH=1
	# Upstream doesn't ship the test data
	local -x SKIP_TEST_JOURNAL_PL=1
	local -x SKIP_TEST_MOUNTABLE_INSPECT_SH=1
	# Sandbox interferes with tests
	local -x SKIP_TEST_BIG_HEAP=1
	local -x SKIP_TEST_SELINUX_XATTRS_FUSE=1
	local -x SKIP_TEST_GUESTUNMOUNT_FD=1
	# Doesn't work correctly when --without-daemon is specified
	local -x SKIP_TEST_NOEXEC_STACK_PL=1
	# Loongarch failures. guestfs_get_architecture returns something other than what's expected
	local -x SKIP_TEST_FILE_ARCHITECTURE_6=1
	local -x SKIP_TEST_FILE_ARCHITECTURE_18=1
	# Upstream appliance not built with sys-apps/file[zstd,-seccomp].
	local -x SKIP_TEST_FILE_ARCHITECTURE_28=1
	# guestfs_part_get_gpt_attributes should return 0x3000000000005, but only returns 0x5 for some reaosn.
	local -x SKIP_TEST_PART_GET_GPT_ATTRIBUTES_0=1
	# Not yet supported by binary appliance 1.54.0
	local -x SKIP_TEST_LARGE_COMMAND_SH=1
	# Socket pathname too long for libvirt backend
	local -x LIBGUESTFS_BACKEND=direct

	# Increase vebosity
	local -x LIBGUESTFS_DEBUG=1
	local -x LIBGUESTFS_TRACE=1

	default
}
