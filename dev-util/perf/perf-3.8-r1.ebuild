# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/perf/perf-3.8-r1.ebuild,v 1.4 2014/10/09 19:47:46 dilfridge Exp $

EAPI="4"

PYTHON_DEPEND="python? 2"
inherit versionator eutils toolchain-funcs python linux-info

MY_PV="${PV/_/-}"
MY_PV="${MY_PV/-pre/-git}"

DESCRIPTION="Userland tools for Linux Performance Counters"
HOMEPAGE="http://perf.wiki.kernel.org/"

LINUX_V="${PV:0:1}.x"
if [[ ${PV/_rc} != ${PV} ]] ; then
	LINUX_VER=$(get_version_component_range 1-2).$(($(get_version_component_range 3)-1))
	PATCH_VERSION=$(get_version_component_range 1-3)
	LINUX_PATCH=patch-${PV//_/-}.bz2
	SRC_URI="mirror://kernel/linux/kernel/v${LINUX_V}/testing/${LINUX_PATCH}
		mirror://kernel/linux/kernel/v${LINUX_V}/testing/v${PATCH_VERSION}/${LINUX_PATCH}"
elif [[ $(get_version_component_count) == 4 ]] ; then
	# stable-release series
	LINUX_VER=$(get_version_component_range 1-3)
	LINUX_PATCH=patch-${PV}.bz2
	SRC_URI="mirror://kernel/linux/kernel/v${LINUX_V}/${LINUX_PATCH}"
else
	LINUX_VER=${PV}
	SRC_URI=""
fi

LINUX_SOURCES="linux-${LINUX_VER}.tar.bz2"
SRC_URI+=" mirror://kernel/linux/kernel/v${LINUX_V}/${LINUX_SOURCES}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~x86"
IUSE="audit +demangle +doc perl python slang unwind"

RDEPEND="audit? ( sys-process/audit )
	demangle? ( sys-devel/binutils )
	perl? ( dev-lang/perl )
	slang? ( dev-libs/newt )
	unwind? ( sys-libs/libunwind )
	dev-libs/elfutils"
DEPEND="${RDEPEND}
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
	use python && python_set_active_version 2
}

src_unpack() {
	local paths=( tools/perf tools/scripts tools/lib include lib "arch/*/include" "arch/*/lib" )

	# We expect the tar implementation to support the -j option (both
	# GNU tar and libarchive's tar support that).
	echo ">>> Unpacking ${LINUX_SOURCES} (${paths[*]}) to ${PWD}"
	tar --wildcards -xpf "${DISTDIR}"/${LINUX_SOURCES} \
		"${paths[@]/#/linux-${LINUX_VER}/}" || die

	if [[ -n ${LINUX_PATCH} ]] ; then
		eshopts_push -o noglob
		ebegin "Filtering partial source patch"
		filterdiff -p1 ${paths[@]/#/-i } -z "${DISTDIR}"/${LINUX_PATCH} > ${P}.patch || die
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
	if [[ -n ${LINUX_PATCH} ]] ; then
		cd "${S_K}"
		epatch "${WORKDIR}"/${P}.patch
	fi

	# Drop some upstream too-developer-oriented flags and fix the
	# Makefile in general
	sed -i \
		-e 's:-Werror::' \
		-e 's:-ggdb3::' \
		-e 's:-fstack-protector-all::' \
		-e 's:^LDFLAGS =:EXTLIBS +=:' \
		-e '/\(PERL\|PYTHON\)_EMBED_LDOPTS/s:ALL_LDFLAGS +=:EXTLIBS +=:' \
		-e '/-x c - /s:\$(ALL_LDFLAGS):\0 $(EXTLIBS):' \
		-e '/^ALL_CFLAGS =/s:$: $(CFLAGS_OPTIMIZE):' \
		-e '/^ALL_LDFLAGS =/s:$: $(LDFLAGS_OPTIMIZE):' \
		-e 's:$(sysconfdir_SQ)/bash_completion.d:/usr/share/bash-completion:' \
		"${S}"/Makefile
	sed -i \
		-e '/.FORCE-PERF-VERSION-FILE/s,.FORCE-PERF-VERSION-FILE,,g' \
		"${S}"/Makefile \
		"${S}"/Documentation/Makefile

	# Avoid the call to make kernelversion
	echo "PERF_VERSION = ${MY_PV}" > PERF-VERSION-FILE

	# The code likes to compile local assembly files which lack ELF markings.
	find -name '*.S' -exec sed -i '$a.section .note.GNU-stack,"",%progbits' {} +
}

puse() { usex $1 "" no; }
perf_make() {
	local arch=$(tc-arch)
	[[ "${arch}" == "amd64" ]] && arch="x86_64"
	emake -j1 V=1 \
		CC="$(tc-getCC)" AR="$(tc-getAR)" \
		prefix="/usr" bindir_relative="sbin" \
		CFLAGS_OPTIMIZE="${CFLAGS}" \
		LDFLAGS_OPTIMIZE="${LDFLAGS}" \
		ARCH="${arch}" \
		NO_DEMANGLE=$(puse demangle) \
		NO_LIBAUDIT=$(puse audit) \
		NO_LIBPERL=$(puse perl) \
		NO_LIBPYTHON=$(puse python) \
		NO_LIBUNWIND=$(puse unwind) \
		NO_NEWT=$(puse slang) \
		"$@"
}

src_compile() {
	perf_make
	use doc && perf_make -C Documentation
}

src_test() {
	:
}

src_install() {
	perf_make install DESTDIR="${D}"

	dodoc CREDITS

	dodoc *txt Documentation/*.txt
	if use doc ; then
		dohtml Documentation/*.html
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
