# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Plugin for Pidgin that reminds you of your buddies birthdays"
HOMEPAGE="https://github.com/kgraefe/pidgin-birthday-reminder"
SRC_URI="https://github.com/kgraefe/pidgin-birthday-reminder/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE="static-libs"

RDEPEND="net-im/pidgin:=[gtk]"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

src_configure() {
	econf \
		$(use_enable static-libs static)
}

src_install() {
	default
	mkdir "${D}/usr/share/metainfo"
	mv "${D}/usr/share/appdata/pidgin-birthday-reminder.metainfo.xml" "${D}/usr/share/metainfo/"
	if ! use static-libs ; then
		find "${D}" -type f -name '*.la' -delete || die "la removal failed"
	fi
}
