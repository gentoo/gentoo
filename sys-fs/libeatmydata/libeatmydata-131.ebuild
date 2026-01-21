# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Multilib because "handy to inject into wine"
VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/stewartsmith.asc
inherit multilib-minimal verify-sig

DESCRIPTION="LD_PRELOAD hack to convert sync()/msync() and the like to NO-OP"
HOMEPAGE="https://www.flamingspork.com/projects/libeatmydata/"
SRC_URI="
	https://www.flamingspork.com/projects/libeatmydata/${P}.tar.gz
	verify-sig? ( https://www.flamingspork.com/projects/libeatmydata/${P}.tar.gz.asc )
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~loong ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? ( dev-debug/strace )
	verify-sig? ( sec-keys/openpgp-keys-stewartsmith )
"

PATCHES=(
	"${FILESDIR}"/${PN}-131-gnu_source.patch
)

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf
}

multilib_src_test() {
	# Sandbox fools LD_PRELOAD and libeatmydata does not get control
	# feature of sandbox
	SANDBOX_ON=0 LD_PRELOAD= emake -k check
}

multilib_src_install_all() {
	find "${ED}" -name '*.la' -type f -delete || die

	dodoc AUTHORS README.md
}
