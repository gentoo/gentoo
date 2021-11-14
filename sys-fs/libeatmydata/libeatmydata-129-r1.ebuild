# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

DESCRIPTION="LD_PRELOAD hack to convert sync()/msync() and the like to NO-OP"
HOMEPAGE="https://www.flamingspork.com/projects/libeatmydata/"
SRC_URI="https://github.com/stewartsmith/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-util/strace )"

ECONF_SOURCE="${S}"

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf --disable-static
}

multilib_src_test() {
	# sandbox fools LD_PRELOAD and libeatmydata does not get control
	# feature of sandbox
	SANDBOX_ON=0 LD_PRELOAD= emake -k check
}

multilib_src_install_all() {
	find "${D}" -name '*.la' -type f -delete || die

	dodoc AUTHORS README.md
}
