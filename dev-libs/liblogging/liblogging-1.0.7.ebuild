# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Easy to use, portable, open source library for system logging"
HOMEPAGE="http://www.liblogging.org"
#SRC_URI="http://download.rsyslog.com/liblogging/${P}.tar.gz"
SRC_URI="https://github.com/rsyslog/liblogging/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD-2"
SLOT="0/0"
KEYWORDS="amd64 arm arm64 ~hppa ~ppc64 ~riscv ~sparc x86"
IUSE="systemd"

RDEPEND="systemd? ( sys-apps/systemd )"
DEPEND="${RDEPEND}"
# Can drop docutils dep if/when release tarballs return
BDEPEND="
	dev-python/docutils
	virtual/pkgconfig
"

DOCS=( ChangeLog )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	append-cflags -std=gnu17

	local myeconfargs=(
		# The package installs nothing if neither of these are
		# enabled. Just enable both as that seems to do no harm.
		--enable-rfc3195
		--enable-stdlog
		$(use_enable systemd journal)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
