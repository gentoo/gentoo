# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Core dump file processor"
HOMEPAGE="https://linutronix.de/minicoredumper"
SRC_URI="https://linutronix.de/minicoredumper/files/${P}.tar.xz"

LICENSE="BSD BSD-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE=""

DEPEND="
	dev-libs/json-c:=
	virtual/libelf
"

RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	# TODO: regd daemon is disabled as there are no known consumers
	local myconf=(
		--enable-static=no
		--runstatedir="${EPREFIX}/run"
		--without-werror
		--without-minicoredumper_trigger
		--without-minicoredumper_regd
		MCD_DUMP_PATH="${EPREFIX}/var/lib/${PN}"
	)
	econf ${myconf[@]}
}

src_install() {
	default

	keepdir /var/lib/minicoredumper

	# systemd-coredump uses /usr/lib/sysctl.d/50-coredump.conf
	insinto /usr/lib/sysctl.d
	doins "${FILESDIR}"/60-minicoredumper.conf

	# it installs some files/dirs we don't want
	rmdir -v "${ED}/run" || die
	rm -rv "${ED}"/etc/{init.d,default} || die

	find "${ED}" -name '*.la' -delete || die
}
