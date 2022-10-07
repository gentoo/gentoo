# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A robust, optimal, and maintainable programming language"
HOMEPAGE="https://ziglang.org/"
SRC_URI="
	amd64? ( https://ziglang.org/download/${PV}/zig-linux-x86_64-${PV}.tar.xz )
	arm? ( https://ziglang.org/download/${PV}/zig-linux-armv7a-${PV}.tar.xz )
	arm64? ( https://ziglang.org/download/${PV}/zig-linux-aarch64-${PV}.tar.xz )
	x86? ( https://ziglang.org/download/${PV}/zig-linux-i386-${PV}.tar.xz )"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm ~arm64 ~x86"

RDEPEND="!dev-lang/zig"

SRC_URI+=" https://codeberg.org/BratishkaErik/distfiles/media/branch/master/zig-0.9.1-fix-detecting-abi.patch"

# Zig provides its standard library in source form "/opt/zig-bin-{PV}/lib/",
# and all other Zig libraries are meant to be consumed in source form,
# because they can use compile-time mechanics (and it is easier for distributions to patch them)
# Here we use this feature for fixing programs that use standard library
# Note: Zig build system is also part of standard library, so we can fix it too
PATCHES=(
	"${FILESDIR}/${P}-fix-bad-hostname-segfault.patch"
	"${DISTDIR}/zig-0.9.1-fix-detecting-abi.patch"
)

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
