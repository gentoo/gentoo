# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit flag-o-matic

DESCRIPTION="Rotix allows you to generate rotational obfuscations"
HOMEPAGE="https://github.com/shemminga/rotix"
SRC_URI="https://github.com/shemminga/${PN}/releases/download/${PV}/${PN}_${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE=""

DEPEND="sys-devel/gettext"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/0.83-respect-CFLAGS-and-dont-strip.patch
"${FILESDIR}"/rotix-0.83-locale.patch
"${FILESDIR}"/rotix-0.83-interix.patch )

src_prepare() {
	default
}

src_configure() {
	use elibc_glibc || append-flags -lintl
	econf --i18n=1
}

src_install() {
	emake DESTDIR="${D}" install
}
