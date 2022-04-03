# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A robust, optimal, and maintainable programming language"
HOMEPAGE="https://ziglang.org/"
SRC_URI="
	amd64? ( https://ziglang.org/download/${PV}/zig-linux-x86_64-${PV}.tar.xz )
	arm? ( https://ziglang.org/download/${PV}/zig-linux-armv7a-${PV}.tar.xz )
	arm64? ( https://ziglang.org/download/${PV}/zig-linux-aarch64-${PV}.tar.xz )
	x86? ( https://ziglang.org/download/${PV}/zig-linux-i386-${PV}.tar.xz )"
KEYWORDS="-* ~amd64 ~arm ~arm64 ~x86"

LICENSE="MIT"
SLOT="0"

RDEPEND="!!dev-lang/zig"
DEPEND=""

src_unpack() {
	unpack ${A}

	mv "${WORKDIR}/"* "${S}"
}

src_install() {
	insinto /opt/
	doins -r "${S}"

	dosym "../../opt/${P}/zig" /usr/bin/zig
	fperms 0755 /usr/bin/zig
}
