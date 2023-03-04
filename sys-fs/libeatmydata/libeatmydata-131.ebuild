# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Multilib because "handy to inject into wine"
inherit multilib-minimal

DESCRIPTION="LD_PRELOAD hack to convert sync()/msync() and the like to NO-OP"
HOMEPAGE="https://www.flamingspork.com/projects/libeatmydata/"
SRC_URI="https://github.com/stewartsmith/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( dev-util/strace )"

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
