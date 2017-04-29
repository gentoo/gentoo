# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# TODO: Add python support.

EAPI="5"

inherit eutils multilib-minimal

DESCRIPTION="high level interface to Linux seccomp filter"
HOMEPAGE="https://github.com/seccomp/libseccomp"
SRC_URI="https://github.com/seccomp/libseccomp/releases/download/v${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="-* amd64 ~arm ~arm64 ~mips ppc ~ppc64 ~s390 x86"
IUSE="static-libs"

# We need newer kernel headers; we don't keep strict control of the exact
# version here, just be safe and pull in the latest stable ones. #551248
DEPEND=">=sys-kernel/linux-headers-4.3"

src_prepare() {
	sed -i \
		-e '/_LDFLAGS/s:-static::' \
		tools/Makefile.in || die
}

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	econf \
		$(use_enable static-libs static) \
		--disable-python
}

multilib_src_install_all() {
	find "${ED}" -name libseccomp.la -delete
	einstalldocs
}
