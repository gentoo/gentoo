# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Core dump file processor"
HOMEPAGE="https://linutronix.de/minicoredumper"
SRC_URI="https://linutronix.de/minicoredumper/files/${P}.tar.xz"

LICENSE="BSD BSD-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

DEPEND="
	dev-libs/json-c:=
	virtual/libelf
"

RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	# regd daemon is disabled as there are no known consumers
	local myconf=(
		--runstatedir="${EPREFIX}/run"
		--with-coreinject
		--with-libminicoredumper
		--with-minicoredumper
		--without-minicoredumper_demo
		--without-minicoredumper_regd
		--without-minicoredumper_trigger
		--without-werror
		MCD_DUMP_PATH="${EPREFIX}/var/lib/${PN}"
	)
	econf ${myconf[@]}
}

src_install() {
	default

	keepdir /var/lib/minicoredumper

	# systemd-coredump uses /usr/lib/sysctl.d/50-coredump.conf
	insinto /usr/lib/sysctl.d
	newins "${FILESDIR}"/60-minicoredumper.conf-r1 60-minicoredumper.conf

	# some files/dirs we don't want
	rmdir -v "${ED}/run" || die
	rm -rv "${ED}"/etc/{init.d,default} || die

	find "${ED}" -name '*.la' -delete || die
}
