# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# TODO: Add python support.

EAPI=7

inherit multilib-minimal

DESCRIPTION="high level interface to Linux seccomp filter"
HOMEPAGE="https://github.com/seccomp/libseccomp"
SRC_URI="https://github.com/seccomp/libseccomp/releases/download/v${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="-* amd64 arm ~arm64 hppa ~mips ppc ppc64 s390 x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

# We need newer kernel headers; we don't keep strict control of the exact
# version here, just be safe and pull in the latest stable ones. #551248
DEPEND=">=sys-kernel/linux-headers-4.3"

PATCHES=(
	"${FILESDIR}/${P}-missing_SNR_ppoll_defs.patch"
)

src_prepare() {
	default
	sed -i \
		-e '/_LDFLAGS/s:-static::' \
		tools/Makefile.in || die
}

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable static-libs static)
		--disable-python
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	find "${ED}" -type f -name libseccomp.la -delete || die
	einstalldocs
}
