# Copyright 2022 Gentoo Authors
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
SLOT="0"
KEYWORDS="-* ~amd64 ~arm ~arm64 ~riscv ~x86"

RDEPEND="!dev-lang/zig"
# Zig provides its standard library in source form "/opt/zig-bin-{PV}/lib/",
# and all other Zig libraries are meant to be consumed in source form,
# because they can use compile-time mechanics (and it is easier for distributions to patch them)
# Here we use this feature for fixing programs that use standard library
# Note: Zig build system is also part of standard library, so we can fix it too
#PATCHES=( )

QA_PREBUILT="opt/${P}/zig"

src_unpack() {
	unpack ${A}

	mv "${WORKDIR}/"* "${S}"
}

src_install() {
	insinto /opt/
	doins -r "${S}"

	dosym -r /opt/${P}/doc/ /usr/share/doc/${PF}
	dosym -r /opt/${P}/zig /usr/bin/zig
	fperms 0755 /usr/bin/zig
}

pkg_postinst() {
	elog "0.10.0 release introduces self-hosted compiler for general use by default"
	elog "It means that your code can be un-compilable since this compiler has some new or removed features and new or fixed bugs"
	elog "Upstream recommends using stage1 if experiencing such breakage,"
	elog "until bugfix release 0.10.1 or release 0.11.0 where old compiler will be fully replaced"
	elog "You can use old compiler by using '-fstage1' flag"
	elog "Also see: https://ziglang.org/download/0.10.0/release-notes.html#Self-Hosted-Compiler"
	elog "and https://ziglang.org/download/0.10.0/release-notes.html#How-to-Upgrade"
}
