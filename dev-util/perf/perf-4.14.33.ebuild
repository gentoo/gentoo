# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit bash-completion-r1 versionator eutils toolchain-funcs python-single-r1 linux-info

MY_PV="${PV/_/-}"
MY_PV="${MY_PV/-pre/-git}"

DESCRIPTION="Userland tools for Linux Performance Counters"
HOMEPAGE="https://perf.wiki.kernel.org/"

LINUX_V="${PV:0:1}.x"
if [[ ${PV} == *_rc* ]] ; then
	LINUX_VER=$(get_version_component_range 1-2).$(($(get_version_component_range 3)-1))
	PATCH_VERSION=$(get_version_component_range 1-3)
	LINUX_PATCH=patch-${PV//_/-}.xz
	SRC_URI="mirror://kernel/linux/kernel/v${LINUX_V}/testing/${LINUX_PATCH}
		mirror://kernel/linux/kernel/v${LINUX_V}/testing/v${PATCH_VERSION}/${LINUX_PATCH}"
else
	VER_COUNT=$(get_version_component_count)
	if [[ ${VER_COUNT} -gt 2 ]] ; then
		# stable-release series
		LINUX_VER=$(get_version_component_range 1-2)
		LINUX_PATCH=patch-${PV}.xz
		SRC_URI="mirror://kernel/linux/kernel/v${LINUX_V}/${LINUX_PATCH}"
	else
		LINUX_VER=${PV}
		SRC_URI=""
	fi
fi

LINUX_SOURCES="linux-${LINUX_VER}.tar.xz"
SRC_URI+=" mirror://kernel/linux/kernel/v${LINUX_V}/${LINUX_SOURCES}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~mips ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="audit debug +demangle +doc gtk numa perl python slang unwind"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="audit? ( sys-process/audit )
	demangle? ( sys-libs/binutils-libs:= )
	gtk? ( x11-libs/gtk+:2 )
	numa? ( sys-process/numactl )
	perl? ( dev-lang/perl )
	python? ( ${PYTHON_DEPS} )
	slang? ( dev-libs/newt )
	unwind? ( sys-libs/libunwind )
	dev-libs/elfutils"
DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-4.9
	${LINUX_PATCH+dev-util/patchutils}
	sys-devel/bison
	sys-devel/flex
	doc? (
		app-text/asciidoc
		app-text/sgml-common
		app-text/xmlto
		sys-process/time
	)"

S_K="${WORKDIR}/linux-${LINUX_VER}"
S="${S_K}/tools/perf"

CONFIG_CHECK="~PERF_EVENTS ~KALLSYMS"

pkg_setup() {
	linux-info_pkg_setup
	use python && python-single-r1_pkg_setup
}

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
			> ${P}.patch || die
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
		cd "${S_K}"
		eapply "${WORKDIR}"/${P}.patch
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
	local arch=$(tc-arch-kernel)
	emake V=1 \
		CC="$(tc-getCC)" AR="$(tc-getAR)" LD="$(tc-getLD)" \
		prefix="${EPREFIX}/usr" bindir_relative="bin" \
		EXTRA_CFLAGS="${CFLAGS}" \
		ARCH="${arch}" \
		NO_DEMANGLE=$(puse demangle) \
		NO_GTK2=$(puse gtk) \
		NO_LIBAUDIT=$(puse audit) \
		NO_LIBPERL=$(puse perl) \
		NO_LIBPYTHON=$(puse python) \
		NO_LIBUNWIND=$(puse unwind) \
		NO_NEWT=$(puse slang) \
		NO_LIBNUMA=$(puse numa) \
		WERROR=0 \
		"$@"
}

src_compile() {
	perf_make -f Makefile.perf
	use doc && perf_make -C Documentation
}

src_test() {
	:
}

src_install() {
	perf_make -f Makefile.perf install DESTDIR="${D}"

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
