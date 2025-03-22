# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${P#pidgin-}"

DESCRIPTION="Bot Sentry is a Pidgin plugin to prevent Instant Message (IM) spam"
HOMEPAGE="https://sourceforge.net/projects/pidgin-bs/"
SRC_URI="https://downloads.sourceforge.net/pidgin-bs/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

RDEPEND="net-im/pidgin[gui]
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-util/intltool-0.40
	virtual/pkgconfig"

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
