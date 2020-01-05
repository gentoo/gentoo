# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )
inherit bash-completion-r1 estack eutils toolchain-funcs python-r1 linux-info

MY_PV="${PV/_/-}"
MY_PV="${MY_PV/-pre/-git}"

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
	SRC_URI=""
fi

LINUX_SOURCES="linux-${LINUX_VER}.tar.xz"
SRC_URI+=" https://www.kernel.org/pub/linux/kernel/v${LINUX_V}/${LINUX_SOURCES}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="audit clang crypt debug +demangle +doc gtk java lzma numa perl python slang systemtap unwind zlib"
# TODO babeltrace
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="audit? ( sys-process/audit )
	crypt? ( dev-libs/openssl:0= )
	clang? (
		sys-devel/clang:*
		sys-devel/llvm:*
	)
	demangle? ( sys-libs/binutils-libs:= )
	gtk? ( x11-libs/gtk+:2 )
	java? ( virtual/jre:* )
	lzma? ( app-arch/xz-utils )
	numa? ( sys-process/numactl )
	perl? ( dev-lang/perl:= )
	python? ( ${PYTHON_DEPS} )
	slang? ( sys-libs/slang )
	systemtap? ( dev-util/systemtap )
	unwind? ( sys-libs/libunwind )
	zlib? ( sys-libs/zlib )
	dev-libs/elfutils"
DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-4.19
	${LINUX_PATCH+dev-util/patchutils}
	sys-devel/bison
	sys-devel/flex
	java? ( virtual/jdk )
	doc? (
		app-text/asciidoc
		app-text/sgml-common
		app-text/xmlto
		sys-process/time
	)"

S_K="${WORKDIR}/linux-${LINUX_VER}"
S="${S_K}/tools/perf"

CONFIG_CHECK="~PERF_EVENTS ~KALLSYMS"

src_unpack() {
	local paths=(
		tools/arch tools/build tools/include tools/lib tools/perf tools/scripts
		include lib "arch/*/lib"
	)

	# We expect the tar implementation to support the -j option (both
	# GNU tar and libarchive's tar support that).
	echo ">>> Unpacking ${LINUX_SOURCES} (${paths[*]}) to ${PWD}"
	tar --wildcards -xpf "${DISTDIR}"/${LINUX_SOURCES} \
		"${paths[@]/#/linux-${LINUX_VER}/}" || die

	if [[ -n ${LINUX_PATCH} ]] ; then
		eshopts_push -o noglob
		ebegin "Filtering partial source patch"
		filterdiff -p1 ${paths[@]/#/-i } -z "${DISTDIR}"/${LINUX_PATCH} \
			> ${P}.patch
		eend $? || die "filterdiff failed"
		eshopts_pop
	fi

	local a
	for a in ${A}; do
		[[ ${a} == ${LINUX_SOURCES} ]] && continue
		[[ ${a} == ${LINUX_PATCH} ]] && continue
		unpack ${a}
	done

	# support clang8
	echo $(clang-major-version)
	if use clang; then
		local old_CC=${CC}
		CC=${CHOST}-clang
		if [[ $(clang-major-version) -ge 8 ]]; then
			pushd "${S_K}" >/dev/null || die
			eapply \
				"${FILESDIR}/perf-5.1.15-fix-clang8.patch" \
				"${FILESDIR}/perf-5.4.6-fix-clang9.patch"
			popd || die
		fi
		CC=${old_CC}
	fi

	pushd "${S_K}" >/dev/null || die
	eapply "${FILESDIR}/perf-5.4.7-propagate-cflags.patch"
	popd || die
}

src_prepare() {
	default
	if [[ -n ${LINUX_PATCH} ]] ; then
		pushd "${S_K}" >/dev/null || die
		eapply "${WORKDIR}"/${P}.patch
		popd || die
	fi

	# Drop some upstream too-developer-oriented flags and fix the
	# Makefile in general
	sed -i \
		-e "s:\$(sysconfdir_SQ)/bash_completion.d:$(get_bashcompdir):" \
		"${S}"/Makefile.perf || die
	# A few places still use -Werror w/out $(WERROR) protection.
	sed -i -e 's:-Werror::' \
		"${S}"/Makefile.perf "${S_K}"/tools/lib/bpf/Makefile || die

	# Avoid the call to make kernelversion
	echo "#define PERF_VERSION \"${MY_PV}\"" > PERF-VERSION-FILE

	# The code likes to compile local assembly files which lack ELF markings.
	find -name '*.S' -exec sed -i '$a.section .note.GNU-stack,"",%progbits' {} +
}

puse() { usex $1 "" no; }
perf_make() {
	# The arch parsing is a bit funky.  The perf tools package is integrated
	# into the kernel, so it wants an ARCH that looks like the kernel arch,
	# but it also wants to know about the split value -- i386/x86_64 vs just
	# x86.  We can get that by telling the func to use an older linux version.
	# It's kind of a hack, but not that bad ...

	# LIBDIR sets a search path of perf-gtk.so. Bug 515954

	local arch=$(tc-arch-kernel)
	local java_dir
	use java && java_dir="/etc/java-config-2/current-system-vm"
	# FIXME: NO_CORESIGHT
	# FIXME: NO_LIBBABELTRACE
	emake V=1 VF=1 \
		CC="$(tc-getCC)" CXX="$(tc-getCXX)" AR="$(tc-getAR)" LD="$(tc-getLD)" \
		prefix="${EPREFIX}/usr" bindir_relative="bin" \
		EXTRA_CFLAGS="${CFLAGS}" \
		ARCH="${arch}" \
		JDIR="${java_dir}" \
		LIBCLANGLLVM=$(usex clang 1 "") \
		NO_AUXTRACE="" \
		NO_BACKTRACE="" \
		NO_CORESIGHT=1 \
		NO_DEMANGLE=$(puse demangle) \
		NO_GTK2=$(puse gtk) \
		NO_JVMTI=$(puse java) \
		NO_LIBAUDIT=$(puse audit) \
		NO_LIBBABELTRACE=1 \
		NO_LIBBIONIC=1 \
		NO_LIBBPF="" \
		NO_LIBCRYPTO=$(puse crypt) \
		NO_LIBDW_DWARF_UNWIND="" \
		NO_LIBELF="" \
		NO_LIBNUMA=$(puse numa) \
		NO_LIBPERL=$(puse perl) \
		NO_LIBPYTHON=$(puse python) \
		NO_LIBUNWIND=$(puse unwind) \
		NO_SDT=$(puse systemtap) \
		NO_SLANG=$(puse slang) \
		NO_LZMA=$(puse lzma) \
		NO_ZLIB= \
		WERROR=0 \
		LIBDIR="/usr/libexec/perf-core" \
		"$@"
}

src_compile() {
	# test-clang.bin not build with g++
	if use clang; then
		pushd "${S_K}/tools/build/feature/" || die
		make V=1 CXX=${CHOST}-clang++ test-clang.bin || die
		popd
	fi
	perf_make -f Makefile.perf
	use doc && perf_make -C Documentation
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

	rm -rv "${ED}"/usr/share/doc/perf-tip || die

	if use gtk; then
		mv "${ED}"/usr/$(get_libdir)/libperf-gtk.so \
			"${ED}"/usr/libexec/perf-core || die
	fi

	dodoc CREDITS

	dodoc *txt Documentation/*.txt
	if use doc ; then
		HTML_DOCS="Documentation/*.html" einstalldocs
		doman Documentation/*.1
	fi
}

pkg_postinst() {
	if ! use doc ; then
		elog "Without the doc USE flag you won't get any documentation nor man pages."
		elog "And without man pages, you won't get any --help output for perf and its"
		elog "sub-tools."
	fi
}
