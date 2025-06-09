# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Bump with app-emulation/libguestfs and app-emulation/libguestfs-appliance (if any new release there)

inherit autotools bash-completion-r1 perl-functions toolchain-funcs

MY_PV_1="$(ver_cut 1-2)"
MY_PV_2="$(ver_cut 2)"
[[ $(( ${MY_PV_2} % 2 )) -eq 0 ]] && SD="stable" || SD="development"

DESCRIPTION="Tools for accessing, inspecting, and modifying virtual machine (VM) disk images"
HOMEPAGE="https://libguestfs.org/"
SRC_URI="https://download.libguestfs.org/${PN}/${MY_PV_1}-${SD}/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0/${MY_PV_1}"
if [[ ${SD} == "stable" ]] ; then
	KEYWORDS="amd64"
fi
IUSE="doc libvirt +ocaml +perl test"
RESTRICT="!test? ( test )"

COMMON_DEPEND_DEFAULT="
	app-arch/xz-utils
	dev-libs/libpcre2:=
	dev-libs/libxml2:=
	sys-libs/libxcrypt:=
	sys-libs/ncurses:=
"
COMMON_DEPEND_EXPLICIT="
	>=app-emulation/libguestfs-1.49.8:=[ocaml,perl?,libvirt=]
	dev-libs/jansson:=
	sys-libs/libosinfo
	|| (
		dev-libs/libisoburn
		app-cdr/cdrtools
	)
"
COMMON_DEPEND_IMPLICIT="
	dev-db/sqlite
	sys-apps/hwdata
"
COMMON_DEPEND="
	${COMMON_DEPEND_DEFAULT}
	${COMMON_DEPEND_EXPLICIT}
	${COMMON_DEPEND_IMPLICIT}
	libvirt? ( app-emulation/libvirt[qemu] )
	perl? (
		app-misc/hivex
		virtual/perl-Getopt-Long
	)
"

# Some OCaml is always required
# bug #729674
DEPEND="
	${COMMON_DEPEND}
	dev-lang/ocaml[ocamlopt]
	dev-ml/findlib[ocamlopt]
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
	ocaml? (
		dev-ml/ocaml-gettext
		dev-ml/ocaml-gettext-stub
	)
	perl? (
		dev-perl/Module-Build
		virtual/perl-ExtUtils-CBuilder
		virtual/perl-Pod-Simple
	)
	test? ( ocaml? ( dev-ml/ounit2[ocamlopt] ) )
"

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

src_configure() {
	# Bug #794877
	tc-export AR

	# m4/guestfs-progs.m4: (f)lex and bison for virt-builder (required).
	# Bug #915339
	unset LEX YACC

	local myconf=(
		$(usex doc '' PO4A=no)
		$(use_enable ocaml)
		$(use_enable perl)
		$(use_with libvirt)
	)

	econf "${myconf[@]}"
}

src_install() {
	emake INSTALLDIRS=vendor DESTDIR="${D}" install "LINGUAS=""${LINGUAS}"""

	find "${ED}" -name '*.la' -delete || die

	use perl && perl_delete_localpod
}

src_test() {
	# Missing appliance support? libguestfs (virt-inspector --format=raw -a ${IMAGE}) returns
	# libguestfs: error: inspect_get_build_id: dispatch_incoming_message: unknown procedure number 513.
	# set LIBGUESTFS_PATH to point to the matching libguestfs appliance directory
	local -x SKIP_TEST_VIRT_INSPECTOR_LVM_ON_LUKS_SH=1
	local -x SKIP_TEST_VIRT_INSPECTOR_LUKS_ON_LVM_SH=1
	local -x SKIP_TEST_VIRT_INSPECTOR_SH=1
	local -x SKIP_TEST_VIRT_DRIVERS_LINUX_SH=1
	local -x SKIP_TEST_VIRT_DRIVERS_WINDOWS_SH=1
	# Misssing appliance support? libguestfs returns
	# virt-make-fs: file command failed
	local -x SKIP_TEST_VIRT_MAKE_FS_SH=1
	# Socket pathname too long for libvirt backend
	local -x LIBGUESTFS_BACKEND=direct
	# Increase vebosity
	local -x LIBGUESTFS_DEBUG=1
	local -x LIBGUESTFS_TRACE=1

	default
}

pkg_postinst() {
	if ! use ocaml ; then
		einfo "OCaml based tools and bindings (virt-resize, virt-sparsify, virt-sysprep, ...) NOT installed"
	fi

	if ! use perl ; then
		einfo "Perl based tools NOT built"
	fi
}
