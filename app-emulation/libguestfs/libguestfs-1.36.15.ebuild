# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} )

inherit autotools bash-completion-r1 eapi7-ver eutils linux-info perl-functions python-single-r1 xdg-utils

MY_PV_1="$(ver_cut 1-2)"
MY_PV_2="$(ver_cut 2)"
[[ $(( ${MY_PV_2} % 2 )) -eq 0 ]] && SD="stable" || SD="development"

DESCRIPTION="Tools for accessing, inspect  and modifying virtual machine (VM) disk images"
HOMEPAGE="http://libguestfs.org/"
SRC_URI="http://libguestfs.org/download/${MY_PV_1}-${SD}/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0/"${MY_PV_1}""

KEYWORDS="~amd64"
IUSE="doc erlang +fuse gtk inspect-icons introspection libvirt lua ocaml +perl python ruby selinux static-libs systemtap test"
RESTRICT="!test? ( test )"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# Failures - doc

# FIXME: selinux support is automagic
COMMON_DEPEND="
	sys-libs/ncurses:0=
	sys-devel/gettext
	>=app-misc/hivex-1.3.1
	dev-libs/libpcre:3
	app-arch/cpio
	dev-lang/perl:=
	virtual/cdrtools
	>=app-emulation/qemu-2.0[qemu_softmmu_targets_x86_64,systemtap?,selinux?,filecaps]
	sys-apps/fakeroot
	sys-apps/file
	libvirt? ( app-emulation/libvirt )
	dev-libs/libxml2:2
	>=sys-apps/fakechroot-2.8
	>=app-admin/augeas-1.0.0
	sys-fs/squashfs-tools:*
	dev-libs/libconfig
	sys-libs/readline:0=
	>=sys-libs/db-4.6:*
	app-arch/xz-utils
	app-arch/lzma
	app-crypt/gnupg
	app-arch/unzip[natspec]
	perl? (
		virtual/perl-ExtUtils-MakeMaker
		>=dev-perl/Sys-Virt-0.2.4
		virtual/perl-Getopt-Long
		virtual/perl-Data-Dumper
		dev-perl/libintl-perl
		>=app-misc/hivex-1.3.1[perl?]
		dev-perl/String-ShellQuote
	)
	python? ( ${PYTHON_DEPS} )
	fuse? ( sys-fs/fuse:= )
	introspection? (
		>=dev-libs/glib-2.26:2
		>=dev-libs/gobject-introspection-1.30.0:=
	)
	selinux? (
		sys-libs/libselinux
		sys-libs/libsemanage
	)
	systemtap? ( dev-util/systemtap )
	ocaml? (
		>=dev-lang/ocaml-4.02[ocamlopt]
		dev-ml/findlib[ocamlopt]
		dev-ml/ocaml-gettext
		>=dev-ml/ounit-2
	)
	erlang? ( dev-lang/erlang )
	inspect-icons? (
		media-libs/netpbm
		media-gfx/icoutils
	)
	virtual/acl
	sys-libs/libcap
	lua? ( dev-lang/lua:* )
	>=dev-libs/yajl-2.0.4
	gtk? (
		sys-apps/dbus
		x11-libs/gtk+:3
	)
	net-libs/libtirpc
	sys-libs/libxcrypt
	"
DEPEND="${COMMON_DEPEND}
	dev-util/gperf
	doc? ( app-text/po4a )
	ruby? ( dev-lang/ruby virtual/rubygems dev-ruby/rake )
	test? ( introspection? ( dev-libs/gjs ) )
	"
RDEPEND="${COMMON_DEPEND}
	app-emulation/libguestfs-appliance
	"

DOCS=( AUTHORS BUGS ChangeLog HACKING README TODO )

PATCHES=(
	"${FILESDIR}"/${MY_PV_1}/0001-Update-libtool-initialization.patch
	"${FILESDIR}"/${MY_PV_1}/0002-Add-support-for-Gentoo-in-distribution-detection.patch
	"${FILESDIR}"/${MY_PV_1}/0003-Fix-install-failure-when-not-built-with-OCaml-suppor.patch
	"${FILESDIR}"/${MY_PV_1}/0004-Loosen-build-time-requirement-on-bash-completion.patch
)

pkg_setup () {
		CONFIG_CHECK="~KVM ~VIRTIO"
		[ -n "${CONFIG_CHECK}" ] && check_extra_config;

		use python && python-single-r1_pkg_setup
}

src_prepare() {
	default
	xdg_environment_reset
	eautoreconf
}

src_configure() {
	# Disable feature test for kvm for more reason
	# i.e: not loaded module in __build__ time,
	# build server not supported kvm, etc. ...
	#
	# In fact, this feature is virtio support and requires
	# configured kernel.
	export vmchannel_test=no

	econf \
		--with-bashcompletiondir="$(get_bashcompdir)" \
		$(use_with libvirt) \
		--disable-appliance \
		--disable-daemon \
		--with-extra="-gentoo" \
		--with-readline \
		--disable-php \
		$(use_enable python) \
		--without-java \
		$(use_enable perl) \
		$(use_enable fuse) \
		$(use_enable ocaml) \
		$(use_enable ruby) \
		--disable-haskell \
		--disable-golang \
		$(use_enable introspection gobject) \
		$(use_enable introspection) \
		$(use_enable erlang) \
		$(use_enable static-libs static) \
		$(use_enable systemtap probes) \
		$(use_enable lua) \
		--with-gtk=$(usex gtk 3 no) \
		$(usex doc '' PO4A=no)
}

src_install() {
	strip-linguas -i po
	emake DESTDIR="${D}" install "LINGUAS=""${LINGUAS}"""
	find "${ED}" -name '*.la' -delete || die
	use perl && perl_delete_localpod
}

pkg_postinst() {
	if ! use gtk ; then
		einfo "virt-p2v NOT installed"
	fi
	if ! use ocaml ; then
		einfo "Ocaml based tools ( sysprep , ... ) NOT installed"
	fi
	if ! use perl ; then
		einfo "Perl based tools NOT build"
	fi
}
