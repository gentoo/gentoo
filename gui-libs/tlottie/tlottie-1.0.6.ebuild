# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cargo flag-o-matic

DESCRIPTION="Rust library for drawing Lottie animations"
HOMEPAGE="https://github.com/dkaraush/tlottie"

SRC_URI="https://github.com/dkaraush/tlottie/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SV="${PV}"
SLOT="0/${SV}"
KEYWORDS="~amd64"

if [ ${PV} = 1.0.6 ]; then
	# Failing tests
	RESTRICT+=" test"
fi

src_prepare() {
	# Patch out optional dependencies (this package has no crate dependencies)
	sed -e '/optional = true/d' \
		-e '/^no-std =/cno-std = []' \
		-i Cargo.toml || die
	default
}

src_configure() {
	local myfeatures=(
		c-api
	)
	cargo_src_configure
}

src_compile() {
	local -Ix LDFLAGS
	append-ldflags -Wl,-soname,libtlottie.so.${SV}
	cargo_src_compile
}

src_install() {
	einstalldocs
	newlib.so "$(cargo_target_dir)/libtlottie.so" libtlottie.so.${SV}
	dosym libtlottie.so.${SV} /usr/$(get_libdir)/libtlottie.so
	insinto /usr/include
	doins include/tlottie.h
}
