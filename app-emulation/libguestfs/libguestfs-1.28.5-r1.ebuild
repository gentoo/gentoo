# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

WANT_LIBTOOL=latest
WANT_AUTOMAKE=1.14
AUTOTOOLS_IN_SOURCE_BUILD=1
PYTHON_COMPAT=( python{2_7,3_{3,4}} )

inherit python-single-r1 autotools-utils autotools versionator eutils \
multilib linux-info perl-module base

MY_PV_1="$(get_version_component_range 1-2)"
MY_PV_2="$(get_version_component_range 2)"
[[ $(( $(get_version_component_range 2) % 2 )) -eq 0 ]] && SD="stable" || SD="development"

DESCRIPTION="Tools for accessing, inspect  and modifying virtual machine (VM) disk images"
HOMEPAGE="http://libguestfs.org/"
SRC_URI="http://libguestfs.org/download/${MY_PV_1}-${SD}/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0/"${MY_PV_1}""

KEYWORDS="~amd64"
IUSE="bash-completion erlang +fuse debug ocaml doc +perl python ruby static-libs
selinux systemtap introspection inspect-icons test lua"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# Failures - doc
# Failures - bash-completion, see GBZ #486306

COMMON_DEPEND="
	sys-libs/ncurses
	sys-devel/gettext
	>=app-misc/hivex-1.3.1
	dev-libs/libpcre
	app-arch/cpio
	dev-lang/perl
	app-cdr/cdrkit
	>=app-emulation/qemu-2.0[qemu_softmmu_targets_x86_64,systemtap?,selinux?,filecaps]
	sys-apps/fakeroot
	sys-apps/file
	app-emulation/libvirt
	dev-libs/libxml2:2
	>=sys-apps/fakechroot-2.8
	>=app-admin/augeas-1.0.0
	sys-fs/squashfs-tools:*
	dev-libs/libconfig
	dev-libs/libpcre
	sys-libs/readline:=
	>=sys-libs/db-4.6:*
	app-arch/xz-utils
	app-arch/lzma
	app-crypt/gnupg
	app-arch/unzip[natspec]
	perl? ( virtual/perl-ExtUtils-MakeMaker
			>=dev-perl/Sys-Virt-0.2.4
			virtual/perl-Getopt-Long
			virtual/perl-Data-Dumper
			dev-perl/libintl-perl
			>=app-misc/hivex-1.3.1[perl?]
			dev-perl/String-ShellQuote
			)
	python? ( ${PYTHON_DEPS} )
	fuse? ( sys-fs/fuse )
	introspection? (
		>=dev-libs/gobject-introspection-1.30.0
		dev-libs/gjs
		)
	selinux? ( sys-libs/libselinux  sys-libs/libsemanage )
	systemtap? ( dev-util/systemtap )
	ocaml? ( dev-lang/ocaml[ocamlopt]
			dev-ml/findlib[ocamlopt]
			dev-ml/ocaml-gettext
			)
	erlang? ( dev-lang/erlang )
	inspect-icons? ( media-libs/netpbm
			media-gfx/icoutils
			)
	virtual/acl
	sys-libs/libcap
	lua? ( dev-lang/lua:* )
	>=app-shells/bash-completion-2.0
	dev-libs/yajl"

DEPEND="${COMMON_DEPEND}
	dev-util/gperf
	doc? ( app-text/po4a )
	ruby? ( dev-lang/ruby virtual/rubygems dev-ruby/rake )
	${AUTOTOOLS_DEPEND}
	"
RDEPEND="${COMMON_DEPEND}
	app-emulation/libguestfs-appliance
	"

PATCHES=( "${FILESDIR}/${MY_PV_1}"/*.patch  )

DOCS=( AUTHORS BUGS ChangeLog HACKING README TODO )

pkg_setup () {
		CONFIG_CHECK="~KVM ~VIRTIO"
		[ -n "${CONFIG_CHECK}" ] && check_extra_config;

		use python && python-single-r1_pkg_setup
}

src_prepare() {
	base_src_prepare
	eaclocal
	eautomake
	eautoconf
}

src_configure() {

	# Disable feature test for kvm for more reason
	# i.e: not loaded module in __build__ time,
	# build server not supported kvm, etc. ...
	#
	# In fact, this feature is virtio support and requires
	# configured kernel.
	export vmchannel_test=no

	local myeconfargs=(
		$(use_enable test werror)
		--with-libvirt
		--with-default-backend=libvirt
		--disable-appliance
		--disable-daemon
		--with-extra="-gentoo"
		--with-readline
		--disable-php
		$(use_enable python)
		--without-java
		$(use_enable perl)
		$(use_enable fuse)
		$(use_enable ocaml)
		$(use_enable ruby)
		--disable-haskell
		--disable-golang
		$(use_enable introspection gobject)
		$(use_enable erlang)
		$(use_enable systemtap probes)
		$(use_enable lua)
	)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile

}

src_test() {
	autotools-utils_src_test
}

src_install() {
	strip-linguas -i po
	autotools-utils_src_install "LINGUAS=""${LINGUAS}"""

	use perl && perl_delete_localpod
}

pkg_postinst() {

	if ! use perl ; then
		einfo "Perl based tools NOT build"
	fi
	if ! use ocaml ; then
		einfo "Ocaml based tools ( sysprep , ... ) NOT installed"
	fi
}
