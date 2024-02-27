# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Erasure Code API library written in C with pluggable Erasure Code backends"
HOMEPAGE="https://bitbucket.org/tsg-/liberasurecode/overview"
SRC_URI="https://github.com/openstack/liberasurecode/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="doc static-libs"

DEPEND="doc? ( app-text/doxygen )"

PATCHES=(
	# bashism in configure.ac
	# Patch submitted upstream as https://review.opendev.org/c/openstack/liberasurecode/+/907156
	"${FILESDIR}"/0001-configure-fix-basic-syntax-errors-in-the-shell-scrip.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {

	# fails with -Werror=lto-type-mismatch
	# https://bugs.launchpad.net/liberasurecode/+bug/2051613
	filter-lto

	econf \
		--htmldir=/usr/share/doc/${PF} \
		--disable-werror \
		$(use_enable doc doxygen) \
		$(use_enable static-libs static)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
