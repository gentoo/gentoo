# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo flag-o-matic linux-info systemd toolchain-funcs udev

DESCRIPTION="Dynamic BPF-based system-wide tracing tool"
HOMEPAGE="https://github.com/oracle/dtrace-utils https://wiki.gentoo.org/wiki/DTrace"

if [[ ${PV} == 9999 ]]; then
	EGIT_BRANCH="devel"
	EGIT_REPO_URI="https://github.com/oracle/dtrace-utils"
	inherit git-r3
else
	SRC_URI="https://github.com/oracle/dtrace-utils/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/dtrace-utils-${PV}

	KEYWORDS="-* ~amd64"
fi

LICENSE="UPL-1.0"
SLOT="0"
IUSE="systemd install-tests"

# XXX: right now, we auto-adapt to whether multilibs are present:
# should we force them to be? how?
#
# XXX: binutils-libs will need an extra patch for what dtrace does with
# it in the absence of in-kernel CTF: it will be backported
# to 2.42, but perhaps a patch would be a good idea before that?
DEPEND="
	dev-libs/elfutils
	dev-libs/libbpf
	dev-libs/libpfm:=
	net-analyzer/wireshark[dumpcap]
	net-libs/libpcap
	>=sys-fs/fuse-3.2.0:3
	>=sys-libs/binutils-libs-2.42:=
	sys-libs/zlib
	systemd? ( sys-apps/systemd )
"
RDEPEND="
	${DEPEND}
	!dev-debug/systemtap
	net-analyzer/wireshark
	install-tests? (
		app-alternatives/bc
		app-editors/vim-core
		dev-build/make
		dev-lang/perl
		dev-util/perf
		net-fs/nfs-utils
		sys-apps/coreutils
		sys-fs/xfsprogs
		sys-process/time
		virtual/jdk
		virtual/perl-IO-Socket-IP
	)
"
BDEPEND="
	dev-build/make
	sys-apps/gawk
	sys-devel/bison
	>=sys-devel/bpf-toolchain-14.1.0
	sys-devel/flex
"
# TODO: Make this optional, valgrind.h is included unconditionally
# https://github.com/oracle/dtrace-utils/issues/80
DEPEND+=" dev-debug/valgrind"

QA_PRESTRIPPED="
	usr/.*/dtrace/testsuite/test/triggers/.*
"
QA_FLAGS_IGNORED="
	usr/.*/dtrace/testsuite/test/triggers/.*
"

pkg_pretend() {
	# TODO: optional kernel patches

	# Basics for debugging information, BPF
	local CONFIG_CHECK="~BPF ~DEBUG_INFO_BTF ~KALLSYMS_ALL"

	CONFIG_CHECK+=" ~CUSE"

	# Tracing
	CONFIG_CHECK+=" ~TRACING"
	CONFIG_CHECK+=" ~UPROBES ~UPROBE_EVENTS"
	CONFIG_CHECK+=" ~FTRACE ~FTRACE_SYSCALLS ~DYNAMIC_FTRACE ~FUNCTION_TRACER"
	CONFIG_CHECK+=" ~FPROBE"
	# DTrace can fallback to kprobes for fbt but people often want them off
	# for security and newer kernels work fine with BPF for that, so
	# let's omit it. kprobes are slower and scale poorly.

	# https://gcc.gnu.org/PR84052
	CONFIG_CHECK+=" !GCC_PLUGIN_RANDSTRUCT"

	if use install-tests ; then
		# See test/modules
		CONFIG_CHECK+=" ~EXT4_FS ~ISO9660_FS ~NFS_FS ~RDS ~TUN"
	fi

	check_extra_config
}

pkg_setup() {
	eval unset ${!LC_*} LANG
}

src_configure() {
	if tc-is-cross-compiler; then
		die "DTrace does not yet support cross-compilation."
	fi

	tc-export CC

	# https://github.com/oracle/dtrace-utils/issues/78
	tc-enables-fortify-source && append-cppflags -U_FORTIFY_SOURCE

	# lld does this by default, so fix that, although lld fails anyway...
	# 'LIBDTRACE_1.0' to symbol 'dtrace_provider_modules' failed: symbol not defined
	append-ldflags $(test-flags-CCLD -Wl,--undefined-version)
	# mold and lld can't cope with some relocation types used, e.g.
	#  'test-triggers--usdt-tst-forker-prov.o:(.SUNW_dof): unknown relocation: R_X86_64_GLOB_DAT'
	tc-ld-force-bfd

	# -fno-semantic-interposition seems to lead to a broken dtrace
	# that can't actually obtain results from probes, even trivial examples
	# just hang.
	filter-flags -fno-semantic-interposition
	filter-lto

	local confargs=(
		# TODO: Maybe we should set the UNPRIV_UID to something? -3 is a bit... kludgy
		--prefix="${EPREFIX}"/usr
		--mandir="${EPREFIX}"/usr/share/man/man8
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
		HAVE_LIBCTF=yes
		HAVE_LIBSYSTEMD=$(usex systemd)
		HAVE_BPFV3=yes
	)

	edo ./configure "${confargs[@]}"
}

src_compile() {
	emake verbose=1 $(usev !install-tests TRIGGERS='')
}

src_test() {
	# Needs root and is also very time-consuming
	:;
}

src_install() {
	emake DESTDIR="${D}" install $(usev install-tests install-test)

	# Stripping the BPF libs breaks them
	dostrip -x "/usr/$(get_libdir)"

	# It's a binary (TODO: move it?)
	docompress -x /usr/share/doc/${PF}/showUSDT

	newinitd "${FILESDIR}"/dtprobed.init dtprobed
}

pkg_postinst() {
	# We need a udev reload to pick up the CUSE device node rules.
	udev_reload

	# TODO: Restart it on upgrade? (it will carry across its own persistent state)
	if [[ -n ${REPLACING_VERSIONS} ]]; then
		# TODO: Make this more intelligent wrt comparison
		if systemd_is_booted ; then
			einfo "Restart the DTrace 'dtprobed' service after upgrades:"
			einfo " systemctl try-restart dtprobed"
		else
			einfo "Restart the DTrace 'dtprobed' service with:"
			einfo " /etc/init.d/dtprobed restart"
		fi
	else
		einfo "See https://wiki.gentoo.org/wiki/DTrace for getting started."

		if systemd_is_booted ; then
			einfo "Enable and start the DTrace 'dtprobed' service with:"
			einfo " systemctl enable --now dtprobed"
		else
			einfo "Enable and start the DTrace 'dtprobed' service with:"
			einfo " rc-update add dtprobed"
			einfo " /etc/init.d/dtprobed start"
		fi
	fi
}

pkg_postrm() {
	udev_reload
}
