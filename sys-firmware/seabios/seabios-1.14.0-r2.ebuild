# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{8,9,10,11} )

inherit toolchain-funcs python-any-r1

# SeaBIOS maintainers sometimes don't release stable tarballs or stable
# binaries to generate the stable tarball the following is necessary:
# git clone git://git.seabios.org/seabios.git && cd seabios
# git archive --output seabios-${PV}.tar.gz --prefix seabios-${PV}/ rel-${PV}

# To generate binary tarball you can run the following from fork tree:
# cd .../seabios-1.14.0-r2/image/usr/share
# $ tar cJf seabios-1.14.0-r2-bin.tar.xz *.bin

if [[ ${PV} == *9999* || -n "${EGIT_COMMIT}" ]] ; then
	EGIT_REPO_URI="git://git.seabios.org/seabios.git"
	inherit git-r3
else
	KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

	SRC_URI="
		!binary? ( https://www.seabios.org/downloads/${P}.tar.gz )
		binary? ( https://dev.gentoo.org/~sam/distfiles/${P}-r2-bin.tar.xz )"
fi

DESCRIPTION="Open Source implementation of a 16-bit x86 BIOS"
HOMEPAGE="https://www.seabios.org/"

LICENSE="LGPL-3 GPL-3"
SLOT="0"
IUSE="+binary debug +seavgabios"

REQUIRED_USE="debug? ( !binary )"

SOURCE_DEPEND="
	>=sys-power/iasl-20060912
	${PYTHON_DEPS}"
DEPEND="
	!binary? (
		${SOURCE_DEPEND}
	)"
RDEPEND=""

choose_target_chost() {
	if [[ -n "${CC}" ]]; then
		${CC} -dumpmachine
		return
	fi

	if use amd64 || use x86; then
		# Use the native compiler
		echo "${CHOST}"
		return
	fi

	local i
	for i in x86_64 i686 i586 i486 i386 ; do
		i=${i}-pc-linux-gnu
		type -P ${i}-gcc > /dev/null && echo ${i} && return
	done
}

pkg_pretend() {
	if ! use binary; then
		ewarn "You have decided to compile your own SeaBIOS. This is not"
		ewarn "supported by upstream unless you use their recommended"
		ewarn "toolchain (which you are not)."
		elog
		ewarn "If you are intending to use this build with QEMU, realize"
		ewarn "you will not receive any support if you have compiled your"
		ewarn "own SeaBIOS. Virtual machines subtly fail based on changes"
		ewarn "in SeaBIOS."
		if [[ -z "$(choose_target_chost)" ]]; then
			elog
			eerror "Before you can compile ${PN}[-binary], you need to install a x86 cross-compiler"
			eerror "Run the following commands:"
			eerror "  emerge crossdev"
			eerror "  crossdev --stable -t x86_64-pc-linux-gnu"
			die "cross-compiler is needed"
		fi
	fi
}

pkg_setup() {
	use binary || python-any-r1_pkg_setup
}

src_unpack() {
	default

	# This simplifies the logic between binary & source builds.
	mkdir -p "${S}"
}

src_prepare() {
	default

	if ! use binary; then
		eapply "${FILESDIR}"/${PN}-1.14.0-binutils-2.36.patch
	fi

	# Ensure precompiled iasl files are never used
	find "${WORKDIR}" -name '*.hex' -delete || die
}

src_configure() {
	use binary && return

	tc-ld-disable-gold #438058

	if use debug ; then
		echo "CONFIG_DEBUG_LEVEL=8" >.config
	fi
	_emake config
}

_emake() {
	LANG=C \
	emake V=1 \
		CPP="$(tc-getPROG CPP cpp)" \
		CC="$(tc-getCC)" \
		LD="$(tc-getLD)" \
		AR="$(tc-getAR)" \
		AS="$(tc-getAS)" \
		OBJCOPY="$(tc-getOBJCOPY)" \
		RANLIB="$(tc-getRANLIB)" \
		OBJDUMP="$(tc-getOBJDUMP)" \
		STRIP="$(tc-getSTRIP)" \
		HOST_CC="$(tc-getBUILD_CC)" \
		VERSION="Gentoo/${EGIT_COMMIT:-${PVR}}" \
		"$@"
}

src_compile() {
	use binary && return

	local TARGET_CHOST=$(choose_target_chost)

	cp "${FILESDIR}/seabios/config.seabios-128k" .config || die
	_emake oldnoconfig
	CHOST="${TARGET_CHOST}" _emake iasl
	CHOST="${TARGET_CHOST}" _emake out/bios.bin
	mv out/bios.bin ../bios.bin || die

	cp "${FILESDIR}/seabios/config.seabios-256k" .config || die
	_emake oldnoconfig
	CHOST="${TARGET_CHOST}" _emake iasl
	CHOST="${TARGET_CHOST}" _emake out/bios.bin
	mv out/bios.bin ../bios-256k.bin || die

	if use seavgabios ; then
		local config t targets=(
			cirrus
			isavga
			qxl
			stdvga
			virtio
			vmware
		)
		for t in "${targets[@]}" ; do
			_emake clean distclean
			cp "${FILESDIR}/seavgabios/config.vga-${t}" .config || die
			_emake oldnoconfig
			CHOST="${TARGET_CHOST}" _emake out/vgabios.bin
			cp out/vgabios.bin ../vgabios-${t}.bin || die
		done
	fi
}

src_install() {
	insinto /usr/share/seabios
	doins ../bios.bin
	doins ../bios-256k.bin

	if use seavgabios ; then
		insinto /usr/share/seavgabios
		doins ../vgabios*.bin
	fi
}
