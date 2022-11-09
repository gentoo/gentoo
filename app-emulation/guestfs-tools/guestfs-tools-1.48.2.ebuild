# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Bump with app-emulation/libguestfs and app-emulation/libguestfs-appliance (if any new release there)

inherit flag-o-matic linux-info perl-functions strip-linguas toolchain-funcs

MY_PV_1="$(ver_cut 1-2)"
MY_PV_2="$(ver_cut 2)"
[[ $(( ${MY_PV_2} % 2 )) -eq 0 ]] && SD="stable" || SD="development"

DESCRIPTION="Tools for accessing, inspecting, and modifying virtual machine (VM) disk images"
HOMEPAGE="https://libguestfs.org/"
SRC_URI="https://download.libguestfs.org/${PN}/${MY_PV_1}-${SD}/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0/${MY_PV_1}"
KEYWORDS="~amd64"
IUSE="doc +ocaml +perl test"
RESTRICT="!test? ( test )"

# Failures - doc
COMMON_DEPEND="
	!<app-emulation/libguestfs-1.46.0-r1
	app-arch/cpio
	app-arch/lzma
	app-arch/unzip[natspec]
	app-arch/xz-utils
	app-crypt/gnupg
	>=app-emulation/libguestfs-${MY_PV_1}:=[ocaml?,perl?]
	app-emulation/libvirt:=
	>=app-emulation/qemu-2.0[qemu_softmmu_targets_x86_64,filecaps]
	dev-lang/perl:=
	dev-libs/libpcre2:=
	dev-libs/libxml2:2
	dev-libs/jansson:=
	>=sys-apps/fakechroot-2.8
	sys-fs/squashfs-tools:*
	sys-libs/ncurses:=
	sys-libs/libxcrypt:=
	virtual/libcrypt:=
	ocaml? ( >=dev-lang/ocaml-4.03:=[ocamlopt] )
	perl? (
		virtual/perl-Data-Dumper
		virtual/perl-Getopt-Long
		dev-perl/Module-Build
		dev-perl/libintl-perl
		virtual/perl-ExtUtils-MakeMaker
		>=dev-perl/Sys-Virt-0.2.4
		dev-perl/String-ShellQuote
		test? ( virtual/perl-Test-Simple )
	)
"
# Some OCaml is always required
# bug #729674
DEPEND="${COMMON_DEPEND}
	>=dev-lang/ocaml-4.03:=[ocamlopt]
	dev-ml/findlib[ocamlopt]
	doc? ( app-text/po4a )
	ocaml? (
		dev-ml/ounit2[ocamlopt]
		|| (
			<dev-ml/ocaml-gettext-0.4.2
			dev-ml/ocaml-gettext-stub[ocamlopt]
		)
	)
"
BDEPEND="virtual/pkgconfig"
RDEPEND="${COMMON_DEPEND}
	app-emulation/libguestfs-appliance
"

DOCS=( AUTHORS BUGS ChangeLog HACKING README TODO )

#PATCHES=(
#	"${FILESDIR}"/${MY_PV_1}/
#)

pkg_setup() {
	CONFIG_CHECK="~KVM ~VIRTIO"
	[[ -n "${CONFIG_CHECK}" ]] && check_extra_config
}

src_configure() {
	# bug #794877
	tc-export AR

	if use test ; then
		# Skip Bash test
		# (See 13-test-suite.log in linked bug)
		# bug #794874
		export SKIP_TEST_COMPLETE_IN_SCRIPT_SH=1

		# This test requires libvirt support in libguestfs and it makes
		# no difference at runtime. Just gracefully skip it to make life
		# easier for e.g. arch testing.
		if ! has_version 'app-emulation/libguestfs[libvirt]' ; then
			export SKIP_TEST_VIRT_ALIGNMENT_SCAN_GUESTS_SH=1
		fi

		# Needed for the inspector tests. Provided by libguestfs-appliance.
		#export LIBGUESTFS_PATH="${BROOT}"/usr/share/guestfs/appliance/
		# But the inspector tests seem fragile anyway...
		export SKIP_TEST_VIRT_INSPECTOR_LUKS_SH=1
		export SKIP_TEST_VIRT_INSPECTOR_SH=1
	fi

	# Disable feature test for kvm for more reason
	# i.e: not loaded module in __build__ time,
	# build server not supported kvm, etc. ...
	#
	# In fact, this feature is virtio support and requires
	# configured kernel.
	export vmchannel_test=no

	# Give a nudge to help find libxcrypt[-system]
	# We have a := dep on virtual/libcrypt to ensure this
	# doesn't become stale.
	# bug #703118, bug #789354
	if ! has_version 'sys-libs/libxcrypt[system]' ; then
		append-ldflags "-L${ESYSROOT}/usr/$(get_libdir)/xcrypt"
		append-ldflags "-Wl,-R${ESYSROOT}/usr/$(get_libdir)/xcrypt"
	fi

	# Test suite at least has a bunch of bashisms
	SHELL="${BROOT}"/bin/bash CONFIG_SHELL="${BROOT}"/bin/bash econf \
		$(usex doc '' PO4A=no) \
		$(use_enable ocaml) \
		$(use_enable perl)
}

src_install() {
	strip-linguas -i po

	emake DESTDIR="${D}" install "LINGUAS=""${LINGUAS}"""

	find "${ED}" -name '*.la' -delete || die

	if use perl ; then
		perl_delete_localpod
	fi
}

pkg_postinst() {
	if ! use ocaml ; then
		einfo "OCaml based tools and bindings (virt-resize, virt-sparsify, virt-sysprep, ...) NOT installed"
	fi

	if ! use perl ; then
		einfo "Perl based tools NOT built"
	fi
}
