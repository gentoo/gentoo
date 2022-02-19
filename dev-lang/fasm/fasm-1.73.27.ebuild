# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs flag-o-matic

DESCRIPTION="Open source assembly language compiler"
HOMEPAGE="https://flatassembler.net"
SRC_URI="https://flatassembler.net/${P}.tgz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="tools libc"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${PN}"
PATCHES=( "${FILESDIR}/1-fix-gnu-stack.patch" )

TOOLS=(listing prepsrc symbols)

pkg_setup() {
	# fasm code is not position-independent, so let's disable PIE
	# linking in hardened profiles to avoid TEXTRELs
	if use libc || use tools; then
		filter-ldflags -Wl,--pie -Wl,-pie -pie
		append-ldflags -no-pie
	fi
	CC=$(tc-getCC)

	# fasm is self-hosted; so, if fasm already installed,
	# assemble it with system fasm, otherwise assemble it
	# with binary provided in tarball
	if has_version -b "${CATEGORY}/${PN}"; then
		FASM="${PN}"
	else
		einfo "Bootstrapping fasm from binary"
		FASM="./${PN}"
		[[ ${ARCH} = "amd64" ]] && FASM+=".x64"
		is_bootstrap=1
	fi
}

src_compile() {
	if use libc; then
		${FASM} "source/libc/fasm.asm" || die
		${CC} -m32 ${LDFLAGS} -o "${T}/${PN}" "source/libc/fasm.o" || die
	elif [[ ${ARCH} = "amd64" ]]; then
		${FASM} "source/Linux/x64/${PN}.asm" "${T}/${PN}" || die
	else # $ARCH = x86
		${FASM} "source/Linux/${PN}.asm" "${T}/${PN}" || die
	fi

	if use tools; then
		# bootstrapping is done at this point, we can use
		# our homebrewed binary for building tools
		[[ -v is_bootstrap ]] && FASM="${T}/${PN}"
		for tool in "${TOOLS[@]}"; do
			${FASM} "tools/libc/${tool}.asm" || die
			${CC} -m32 ${LDFLAGS} -o "${T}/${tool}" "tools/libc/${tool}.o" || die
		done
	fi
}

src_test() {
	FASM="${T}/${PN}"
	mkdir "${T}/tst"
	FASM_DST="${T}/tst/st2"

	# Check that assemled assembler can assemble itself and
	# resulting binaries are identical
	if use libc; then
		FASM_SRC="source/libc/${PN}.asm"
	elif [[ ${ARCH} = "amd64" ]]; then
		FASM_SRC="source/Linux/x64/${PN}.asm"
	else # $ARCH = x86
		FASM_SRC="source/Linux/${PN}.asm"
	fi

	einfo "Checking that assembled fasm can assemble itself"
	${FASM} "${FASM_SRC}" "${FASM_DST}" || die "fasm failed to assemble itself"

	einfo "Checking that stage-2 fasm is identical to stage-1"
	use libc && FASM="source/libc/${PN}.o"
	cmp "${FASM}" "${FASM_DST}" || die "stage-1 binary \"${FASM}\" is not identical to stage-2 binary \"${FASM_DST}\""
}

src_install() {
	exeinto /usr/bin
	doexe "${T}/${PN}"
	dodoc "${PN}.txt"
	if use tools; then
		for tool in "${TOOLS[@]}"; do
			doexe "${T}/${tool}"
		done
		dodoc "tools/fas.txt"
	fi
}
