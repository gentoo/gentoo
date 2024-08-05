# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
inherit bash-completion-r1 estack flag-o-matic linux-info llvm toolchain-funcs python-r1

DESCRIPTION="Userland tools for Linux Performance Counters"
HOMEPAGE="https://perf.wiki.kernel.org/"

LINUX_V="${PV:0:1}.x"
if [[ ${PV} == *_rc* ]] ; then
	LINUX_VER=$(ver_cut 1-2).$(($(ver_cut 3)-1))
	PATCH_VERSION=$(ver_cut 1-3)
	LINUX_PATCH=patch-${PV//_/-}.xz
	SRC_URI="https://www.kernel.org/pub/linux/kernel/v${LINUX_V}/testing/${LINUX_PATCH}
		https://www.kernel.org/pub/linux/kernel/v${LINUX_V}/testing/v${PATCH_VERSION}/${LINUX_PATCH}"
elif [[ ${PV} == *.*.* ]] ; then
	# stable-release series
	LINUX_VER=$(ver_cut 1-2)
	LINUX_PATCH=patch-${PV}.xz
	SRC_URI="https://www.kernel.org/pub/linux/kernel/v${LINUX_V}/${LINUX_PATCH}"
else
	LINUX_VER=${PV}
fi

LINUX_SOURCES="linux-${LINUX_VER}.tar.xz"
SRC_URI+=" https://www.kernel.org/pub/linux/kernel/v${LINUX_V}/${LINUX_SOURCES}"

S_K="${WORKDIR}/linux-${LINUX_VER}"
S="${S_K}/tools/perf"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux"
IUSE="abi_mips_o32 abi_mips_n32 abi_mips_n64 audit babeltrace capstone big-endian bpf caps crypt debug +doc gtk java libpfm +libtraceevent +libtracefs lzma numa perl python slang systemtap tcmalloc unwind zstd"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"

# setuptools (and Python) are always needed even if not building Python bindings
BDEPEND="
	${LINUX_PATCH+dev-util/patchutils}
	${PYTHON_DEPS}
	>=app-arch/tar-1.34-r2
	dev-python/setuptools[${PYTHON_USEDEP}]
	app-alternatives/yacc
	app-alternatives/lex
	virtual/pkgconfig
	doc? (
		app-text/asciidoc
		app-text/sgml-common
		app-text/xmlto
		sys-process/time
	)
"

RDEPEND="
	audit? ( sys-process/audit )
	babeltrace? ( dev-util/babeltrace:0/1 )
	bpf? (
		dev-libs/libbpf
		dev-util/bpftool
		dev-util/pahole
		sys-devel/clang:=
		sys-devel/llvm:=
	)
	caps? ( sys-libs/libcap )
	capstone? ( dev-libs/capstone )
	crypt? ( dev-libs/openssl:= )
	gtk? ( x11-libs/gtk+:2 )
	java? ( virtual/jre:* )
	libpfm? ( dev-libs/libpfm:= )
	libtraceevent? ( dev-libs/libtraceevent )
	libtracefs? ( dev-libs/libtracefs )
	lzma? ( app-arch/xz-utils )
	numa? ( sys-process/numactl )
	perl? ( dev-lang/perl:= )
	python? ( ${PYTHON_DEPS} )
	slang? ( sys-libs/slang )
	systemtap? ( dev-debug/systemtap )
	tcmalloc? ( dev-util/google-perftools )
	unwind? ( sys-libs/libunwind:= )
	zstd? ( app-arch/zstd:= )
	dev-libs/elfutils
	sys-libs/binutils-libs:=
	sys-libs/zlib
	virtual/libcrypt
"

DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-5.10
	java? ( virtual/jdk )
"

QA_FLAGS_IGNORED=(
	'usr/bin/perf-read-vdso32' # not linked with anything except for libc
	'usr/libexec/perf-core/dlfilters/.*' # plugins
)

pkg_pretend() {
	if ! use doc ; then
		ewarn "Without the doc USE flag you won't get any documentation nor man pages."
		ewarn "And without man pages, you won't get any --help output for perf and its"
		ewarn "sub-tools."
	fi
}

pkg_setup() {
	local CONFIG_CHECK="
		~DEBUG_INFO
		~FTRACE
		~FTRACE_SYSCALLS
		~FUNCTION_TRACER
		~KALLSYMS
		~KALLSYMS_ALL
		~KPROBES
		~KPROBE_EVENTS
		~PERF_EVENTS
		~UPROBES
		~UPROBE_EVENTS
	"

	use bpf && llvm_pkg_setup
	# We enable python unconditionally as libbpf always generates
	# API headers using python script
	python_setup

	if use bpf ; then
		CONFIG_CHECK+="~BPF ~BPF_EVENTS ~BPF_SYSCALL ~DEBUG_INFO_BTF ~HAVE_EBPF_JIT"
	fi

	linux-info_pkg_setup
}

# src_unpack and src_prepare are copied to dev-util/bpftool since
# it's building from the same tarball, please keep it in sync with bpftool
src_unpack() {
	local paths=(
		'arch/*/include/*' 'arch/*/lib/*' 'arch/*/tools/*' 'include/*'
		'kernel/bpf/*' 'lib/*' 'scripts/*' 'tools/arch/*' 'tools/bpf/*'
		'tools/build/*' 'tools/include/*' 'tools/lib/*' 'tools/perf/*'
		'tools/scripts/*'
	)

	# We expect the tar implementation to support the -j option (both
	# GNU tar and libarchive's tar support that).
	echo ">>> Unpacking ${LINUX_SOURCES} (${paths[*]}) to ${PWD}"
	gtar --wildcards -xpf "${DISTDIR}"/${LINUX_SOURCES} \
		"${paths[@]/#/linux-${LINUX_VER}/}" || die

	if [[ -n ${LINUX_PATCH} ]] ; then
		eshopts_push -o noglob
		ebegin "Filtering partial source patch"
		xzcat "${DISTDIR}"/${LINUX_PATCH} | filterdiff -p1 ${paths[@]/#/-i} > ${P}.patch
        test -s ${P}.patch
        assert -n "Unpacking to ${P} from ${DISTDIR}/${LINUX_PATCH} failed"
		eend $? || die "filterdiff failed"
		eshopts_pop
	fi

	local a
	for a in ${A}; do
		[[ ${a} == ${LINUX_SOURCES} ]] && continue
		[[ ${a} == ${LINUX_PATCH} ]] && continue
		unpack ${a}
	done
}

src_prepare() {
	default
	if [[ -n ${LINUX_PATCH} ]] ; then
		pushd "${S_K}" >/dev/null || die
		eapply "${WORKDIR}"/${P}.patch
		popd || die
	fi

	pushd "${S_K}" >/dev/null || die
	eapply "${FILESDIR}"/perf-6.4-libtracefs.patch
	eapply "${FILESDIR}"/perf-6.10-expr.patch
	popd || die

	# Drop some upstream too-developer-oriented flags and fix the
	# Makefile in general
	sed -i \
		-e "s@\$(sysconfdir_SQ)/bash_completion.d@$(get_bashcompdir)@" \
		"${S}"/Makefile.perf || die
	# A few places still use -Werror w/out $(WERROR) protection.
	sed -i -e 's@-Werror@@' \
		"${S}"/Makefile.perf "${S_K}"/tools/lib/bpf/Makefile \
		"${S_K}"/tools/lib/perf/Makefile || die

	# Avoid the call to make kernelversion
	sed -i -e '/PERF-VERSION-GEN/d' Makefile.perf || die
	echo "#define PERF_VERSION \"${PV}\"" > PERF-VERSION-FILE

	# The code likes to compile local assembly files which lack ELF markings.
	find -name '*.S' -exec sed -i '$a.section .note.GNU-stack,"",%progbits' {} +
}

puse() { usex $1 "" 1; }
perf_make() {
	# The arch parsing is a bit funky.  The perf tools package is integrated
	# into the kernel, so it wants an ARCH that looks like the kernel arch,
	# but it also wants to know about the split value -- i386/x86_64 vs just
	# x86.  We can get that by telling the func to use an older linux version.
	# It's kind of a hack, but not that bad ...

	# LIBDIR sets a search path of perf-gtk.so. Bug 515954

	local arch=$(tc-arch-kernel)
	local java_dir
	use java && java_dir="${EPREFIX}/etc/java-config-2/current-system-vm"

	# sync this with the whitelist in tools/perf/Makefile.config
	local disable_libdw
	if ! use amd64 && ! use x86 && \
	   ! use arm && \
	   ! use arm64 && \
	   ! use ppc && ! use ppc64 \
	   ! use s390 && \
	   ! use riscv && \
	   ! use loong
	then
		disable_libdw=1
	fi

	# perf directly invokes LD for linking without going through CC, on mips
	# it is required to specify the emulation.  port of below buildroot patch
	# https://patchwork.ozlabs.org/project/buildroot/patch/20170217105905.32151-1-Vincent.Riera@imgtec.com/
	local linker="$(tc-getLD)"
	if use mips
	then
		if use big-endian
		then
			use abi_mips_n64 && linker+=" -m elf64btsmip"
			use abi_mips_n32 && linker+=" -m elf32btsmipn32"
			use abi_mips_o32 && linker+=" -m elf32btsmip"
		else
			use abi_mips_n64 && linker+=" -m elf64ltsmip"
			use abi_mips_n32 && linker+=" -m elf32ltsmipn32"
			use abi_mips_o32 && linker+=" -m elf32ltsmip"
		fi
	fi

	# FIXME: NO_CORESIGHT
	local emakeargs=(
		V=1 VF=1
		HOSTCC="$(tc-getBUILD_CC)" HOSTLD="$(tc-getBUILD_LD)"
		CC="$(tc-getCC)" CXX="$(tc-getCXX)" AR="$(tc-getAR)" LD="${linker}" NM="$(tc-getNM)"
		PKG_CONFIG="$(tc-getPKG_CONFIG)"
		prefix="${EPREFIX}/usr" bindir_relative="bin"
		tipdir="share/doc/${PF}"
		EXTRA_CFLAGS="${CFLAGS}"
		EXTRA_LDFLAGS="${LDFLAGS}"
		ARCH="${arch}"
		BUILD_BPF_SKEL=$(usex bpf 1 "") \
		BUILD_NONDISTRO=1
		JDIR="${java_dir}"
		CORESIGHT=
		GTK2=$(usex gtk 1 "")
		feature-gtk2-infobar=$(usex gtk 1 "")
		NO_AUXTRACE=
		NO_BACKTRACE=
		NO_CAPSTONE=$(puse capstone)
		NO_DEMANGLE=
		NO_JEVENTS=$(puse python)
		NO_JVMTI=$(puse java)
		NO_LIBAUDIT=$(puse audit)
		NO_LIBBABELTRACE=$(puse babeltrace)
		NO_LIBBIONIC=1
		NO_LIBBPF=$(puse bpf)
		NO_LIBCAP=$(puse caps)
		NO_LIBCRYPTO=$(puse crypt)
		NO_LIBDW_DWARF_UNWIND="${disable_libdw}"
		NO_LIBELF=
		NO_LIBNUMA=$(puse numa)
		NO_LIBPERL=$(puse perl)
		NO_LIBPFM4=$(puse libpfm)
		NO_LIBPYTHON=$(puse python)
		NO_LIBTRACEEVENT=$(puse libtraceevent)
		NO_LIBUNWIND=$(puse unwind)
		NO_LIBZSTD=$(puse zstd)
		NO_SDT=$(puse systemtap)
		NO_SHELLCHECK=1
		NO_SLANG=$(puse slang)
		NO_LZMA=$(puse lzma)
		NO_ZLIB=
		TCMALLOC=$(usex tcmalloc 1 "")
		WERROR=0
		DEBUG=$(usex debug 1 "")
		LIBDIR="/usr/libexec/perf-core"
		libdir="${EPREFIX}/usr/$(get_libdir)"
		plugindir="${EPREFIX}/usr/$(get_libdir)/perf/plugins"
		"$@"
	)
	emake "${emakeargs[@]}"
}

src_compile() {
	filter-lto

	perf_make -f Makefile.perf
	use doc && perf_make -C Documentation man
}

src_test() {
	:
}

src_install() {
	_install_python_ext() {
		perf_make -f Makefile.perf install-python_ext DESTDIR="${D}"
	}

	perf_make -f Makefile.perf install DESTDIR="${D}"

	if use python; then
		python_foreach_impl _install_python_ext
	fi

	if use gtk; then
		local libdir
		libdir="$(get_libdir)"
		# on some arches it ends up in lib even on 64bit, ppc64 for instance.
		[[ -f "${ED}"/usr/lib/libperf-gtk.so ]] && libdir="lib"
		mv "${ED}"/usr/${libdir}/libperf-gtk.so \
			"${ED}"/usr/libexec/perf-core || die
	fi

	dodoc CREDITS

	dodoc *txt Documentation/*.txt

	# perf needs this decompressed to print out tips for users
	docompress -x /usr/share/doc/${PF}/tips.txt

	if use doc ; then
		doman Documentation/*.1
	fi
}
