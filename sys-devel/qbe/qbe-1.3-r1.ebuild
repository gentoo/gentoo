# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit toolchain-funcs

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="git://c9x.me/qbe.git"
	inherit git-r3
else
	SRC_URI="https://c9x.me/compile/release/${P}.tar.xz"

	# 64-bit RISC-V only
	KEYWORDS="~amd64 ~arm64 ~riscv"
fi

DESCRIPTION="Pure-C embeddable compiler backend"
HOMEPAGE="https://c9x.me/compile/"

LICENSE="MIT"
SLOT="0"

DOCS=( README doc )

PATCHES=(
	"${FILESDIR}/qbe-1.3-fix-strict-aliasing.patch"
)

src_prepare() {
	default

	sed -i 's;^CC *=.*;CC ?= cc;' Makefile || die

	# Needs to exec test binaries and /tmp can be mounted noexec
	sed -i "s;^tmp=/tmp/;tmp=${T}/;" tools/test.sh || die

	if use elibc_mingw; then
		# MinGW-gcc `-o qbe` forces filename to qbe.exe instead of qbe
		sed -i 's,qbe,qbe.exe,g' Makefile || die

		# same .exe adjusment, and need wine to run qbe.exe in our case
		sed -i \
			-e '/^	bin=/s,qbe,qbe.exe,' \
			-e '/	amd64_win[)]/,/	""[)]/s,bin=",bin="wine ,' \
			tools/test.sh || die
	fi
}

src_configure() {
	# qbe's Makefile uses uname(1), leading to wrong default
	# target when cross-compiling
	if use elibc_Darwin; then
		case ${CTARGET:-$CHOST} in
		*aarch64*) echo '#define Deftgt T_arm64_apple' ;;
		*x86_64*) echo '#define Deftgt T_amd64_apple' ;;
		*) die "Unsupported target ${CTARGET:-$CHOST}" ;;
		esac
	elif use elibc_mingw; then
		case ${CTARGET:-$CHOST} in
		*x86_64*) echo '#define Deftgt T_amd64_win' ;;
		*) die "Unsupported target ${CTARGET:-$CHOST}" ;;
		esac
	else
		case ${CTARGET:-$CHOST} in
		*aarch64*) echo '#define Deftgt T_arm64' ;;
		*riscv64*) echo '#define Deftgt T_rv64' ;;
		*x86_64*) echo '#define Deftgt T_amd64_sysv' ;;
		*) die "Unsupported target ${CTARGET:-$CHOST}" ;;
		esac
	fi > config.h || die
}

src_compile() {
	tc-export CC

	emake CFLAGS="-std=c99 ${CPPFLAGS} ${CFLAGS}"
}

src_install() {
	einstalldocs
	emake install DESTDIR="${ED}" PREFIX=/usr
}
