# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="QuickJS, the Next Generation: a mighty JavaScript engine"
HOMEPAGE="https://github.com/quickjs-ng/quickjs"
SRC_URI="
	https://github.com/quickjs-ng/quickjs/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"

MY_PN="quickjs"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="MIT"
SLOT="0/$(ver_cut 1)"
KEYWORDS="amd64 arm64"

IUSE="test"
RESTRICT="!test? ( test )"

src_prepare() {
	# meson.build is a bit behind: specifies version 0.10.1 when it should be
	# 0.11.0.
	sed -E -i "s/^\s*version: '.*'/version: '${PV}'/" meson.build || die "sed failed"
	default
}

src_configure() {
	local emesonargs=(
		-Ddefault_library=shared # default_library=static hardcoded.
		-Ddocdir="${EPREFIX}/usr/share/doc/${PF}"
		"$(meson_feature test tests)"
		-Dlibc=true
		-Dexamples=disabled
	)
	meson_src_configure
}

src_install() {
	# Source code files under examples.
	docompress -x "/usr/share/doc/${PF}/examples"
	meson_src_install
}
