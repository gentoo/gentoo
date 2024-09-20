# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_METHOD=minisig
VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/minisig-keys/zig-software-foundation.pub
inherit verify-sig

DESCRIPTION="A robust, optimal, and maintainable programming language"
HOMEPAGE="https://ziglang.org/"
SRC_URI="
	amd64? ( https://ziglang.org/download/${PV}/zig-linux-x86_64-${PV}.tar.xz )
	arm? ( https://ziglang.org/download/${PV}/zig-linux-armv7a-${PV}.tar.xz )
	arm64? ( https://ziglang.org/download/${PV}/zig-linux-aarch64-${PV}.tar.xz )
	ppc64? ( https://ziglang.org/download/${PV}/zig-linux-powerpc64le-${PV}.tar.xz )
	riscv? ( https://ziglang.org/download/${PV}/zig-linux-riscv64-${PV}.tar.xz )
	x86? ( https://ziglang.org/download/${PV}/zig-linux-x86-${PV}.tar.xz )
	verify-sig? (
		amd64? ( https://ziglang.org/download/${PV}/zig-linux-x86_64-${PV}.tar.xz.minisig )
		arm? ( https://ziglang.org/download/${PV}/zig-linux-armv7a-${PV}.tar.xz.minisig )
		arm64? ( https://ziglang.org/download/${PV}/zig-linux-aarch64-${PV}.tar.xz.minisig )
		ppc64? ( https://ziglang.org/download/${PV}/zig-linux-powerpc64le-${PV}.tar.xz.minisig )
		riscv? ( https://ziglang.org/download/${PV}/zig-linux-riscv64-${PV}.tar.xz.minisig )
		x86? ( https://ziglang.org/download/${PV}/zig-linux-x86-${PV}.tar.xz.minisig )
	)
"

# project itself: MIT
# There are bunch of projects under "lib/" folder that are needed for cross-compilation.
# Files that are unnecessary for cross-compilation are removed by upstream
# and therefore their licenses (if any special) are not included.
# lib/libunwind: Apache-2.0-with-LLVM-exceptions || ( UoI-NCSA MIT )
# lib/libcxxabi: Apache-2.0-with-LLVM-exceptions || ( UoI-NCSA MIT )
# lib/libcxx: Apache-2.0-with-LLVM-exceptions || ( UoI-NCSA MIT )
# lib/libc/wasi: || ( Apache-2.0-with-LLVM-exceptions Apache-2.0 MIT BSD-2 ) public-domain
# lib/libc/musl: MIT BSD-2
# lib/libc/mingw: ZPL public-domain BSD-2 ISC HPND
# lib/libc/glibc: BSD HPND ISC inner-net LGPL-2.1+
LICENSE="MIT Apache-2.0-with-LLVM-exceptions || ( UoI-NCSA MIT ) || ( Apache-2.0-with-LLVM-exceptions Apache-2.0 MIT BSD-2 ) public-domain BSD-2 ZPL ISC HPND BSD inner-net LGPL-2.1+"
SLOT="$(ver_cut 1-2)"
KEYWORDS="-* ~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

BDEPEND="verify-sig? ( sec-keys/minisig-keys-zig-software-foundation )"
IDEPEND="app-eselect/eselect-zig"

DOCS=( "README.md" )
HTML_DOCS=( "doc/langref.html" )

# Zig provides its standard library and some compiler code in source form "/opt/zig-bin-{PV}/lib/".
# Here we use this feature to fix programs that use standard library.
# Note: Zig build system is also part of standard library, so we can fix it too.
# Don't remove this comment so that other contributors won't be misleaded by "-bin" suffix.
#PATCHES=()

QA_PREBUILT="opt/zig-bin-${PV}/zig"

src_unpack() {
	verify-sig_src_unpack

	mv "${WORKDIR}/"* "${S}" || die
}

src_install() {
	insinto /opt/

	einstalldocs
	rm README.md || die
	rm -r ./doc/ || die

	doins -r "${S}"
	fperms 0755 /opt/zig-bin-${PV}/zig
	dosym -r /opt/zig-bin-${PV}/zig /usr/bin/zig-bin-${PV}
}

pkg_postinst() {
	eselect zig update ifunset || die

	elog "Starting from 0.12.0, Zig no longer installs"
	elog "precompiled standard library documentation."
	elog "Instead, you can call \`zig std\` to compile it on-the-fly."
	elog "It reflects all edits in standard library automatically."
	elog "See \`zig std --help\` for more information."
	elog "More details here: https://ziglang.org/download/0.12.0/release-notes.html#Redesign-How-Autodoc-Works"
}

pkg_postrm() {
	eselect zig update ifunset || die
}
