# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools multilib-minimal

EGIT_COMMIT="a7111e51eac3086264fcca0c7026de22b5ab55c7"
DESCRIPTION="Transparent application input fuzzer"
HOMEPAGE="http://caca.zoy.org/wiki/zzuf"
SRC_URI="https://github.com/samhocevar/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"

# Uses dlopen hack to hijack many libc functions.
# Fails 2 tests with sandbox enabled: check-zzuf-A-autoinc check-utils
RESTRICT="test"

DOCS=( AUTHORS COPYING TODO )

PATCHES=(
	"${FILESDIR}"/${PN}-0.15_autoconf-hardcoded-cflags.patch
	"${FILESDIR}"/${PN}-0.15_autoconf-musl.patch
	"${FILESDIR}"/${PN}-0.15_implicit_functions.patch
	"${FILESDIR}"/${PN}-0.15_use-after-free.patch
)

S="${WORKDIR}"/${PN}-${EGIT_COMMIT}

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf
}

multilib_src_install_all() {
	default

	find "${ED}" -name '*.la' -delete || die
}
