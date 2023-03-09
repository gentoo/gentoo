# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A robust, optimal, and maintainable programming language"
HOMEPAGE="https://ziglang.org/"
SRC_URI="
	amd64? ( https://ziglang.org/download/${PV}/zig-linux-x86_64-${PV}.tar.xz )
	arm? ( https://ziglang.org/download/${PV}/zig-linux-armv7a-${PV}.tar.xz )
	arm64? ( https://ziglang.org/download/${PV}/zig-linux-aarch64-${PV}.tar.xz )
	riscv? ( https://ziglang.org/download/${PV}/zig-linux-riscv64-${PV}.tar.xz )
	x86? ( https://ziglang.org/download/${PV}/zig-linux-i386-${PV}.tar.xz )"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="-* ~amd64 ~arm ~arm64 ~riscv ~x86"
IUSE="doc"

IDEPEND="app-eselect/eselect-zig"
# Zig provides its standard library in source form "/opt/zig-bin-{PV}/lib/",
# and all other Zig libraries are meant to be consumed in source form,
# because they can use compile-time mechanics (and it is easier for distributions to patch them)
# Here we use this feature for fixing programs that use standard library
# Note: Zig build system is also part of standard library, so we can fix it too
#PATCHES=( )

QA_PREBUILT="opt/${P}/zig"

src_unpack() {
	unpack ${A}

	mv "${WORKDIR}/"* "${S}" || die
}

src_install() {
	insinto /opt/

	use doc && local HTML_DOCS=( "doc/langref.html" "doc/std/" )
	einstalldocs
	rm -r ./doc/ || die

	doins -r "${S}"
	fperms 0755 "/opt/${P}/zig"
	dosym -r "/opt/${P}/zig" "/usr/bin/zig-bin-${PV}"
}

pkg_postinst() {
	eselect zig update ifunset

	elog "0.10.1 release uses self-hosted compiler by default and fixes some bugs from 0.10.0"
	elog "But your code still can be un-compilable since some features still not implemented or bugs not fixed"
	elog "Upstream recommends:"
	elog " * Using old compiler if experiencing such breakage (flag '-fstage1')"
	elog " * Waiting for release 0.11.0 with old compiler removed (these changes are already merged in 9999)"
	elog "Also see: https://ziglang.org/download/0.10.0/release-notes.html#Self-Hosted-Compiler"
	elog "and https://ziglang.org/download/0.10.0/release-notes.html#How-to-Upgrade"
}

pkg_postrm() {
	eselect zig update ifunset
}
