# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit flag-o-matic autotools linux-info multilib-minimal

DESCRIPTION="Tools for Linux Kernel Stream Control Transmission Protocol implementation"
HOMEPAGE="http://lksctp.sourceforge.net/"
SRC_URI="https://github.com/sctp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( GPL-2+ LGPL-2.1 )"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86"
IUSE="kernel_linux static-libs"

# This is only supposed to work with Linux to begin with.
DEPEND=">=sys-kernel/linux-headers-2.6"
RDEPEND=""

REQUIRED_USE="kernel_linux"

CONFIG_CHECK="~IP_SCTP"
WARNING_IP_SCTP="CONFIG_IP_SCTP:\tis not set when it should be."

DOCS=( AUTHORS ChangeLog INSTALL NEWS README ROADMAP )

PATCHES=(
	"${FILESDIR}"/${P}-install-sctp.h.patch
	"${FILESDIR}"/${P}-autoconf-2.70.patch
)

src_prepare() {
	default

	eautoreconf

	multilib_copy_sources
}

multilib_src_configure() {
	append-flags -fno-strict-aliasing

	local myeconfargs=(
		--enable-shared
		$(use_enable static-libs static)
	)

	econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	default

	dodoc doc/*txt
	newdoc src/withsctp/README README.withsctp

	find "${ED}" -name '*.la' -delete || die
	if ! use static-libs ; then
		find "${ED}" -name "*.a" -delete || die
	fi
}
