# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

# https://github.com/phhusson/quassel-irssi/pull/10 if accepted will
# allow QuasselC to be installed as a separate package.
QC_VER="0_p20150406"

DESCRIPTION="Irssi module to connect to Quassel cores."
HOMEPAGE="https://github.com/phhusson/quassel-irssi/"
SRC_URI="https://dev.gentoo.org/~wraeth/distfiles/${P}.tar.gz
	https://dev.gentoo.org/~wraeth/distfiles/quasselc-${QC_VER}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="net-irc/irssi"
RDEPEND="${DEPEND}"

src_prepare() {
	mv "${WORKDIR}"/quasselc-"${QC_VER}"/* "${S}"/core/lib/ || die
	default
}

src_compile() {
	emake IRSSI_LIB="${ROOT}/usr/$(get_libdir)/irssi" -C core
}

src_install() {
	emake DESTDIR="${D}" LIBDIR="${ROOT}usr/$(get_libdir)" -C core install
	default
}

pkg_postinst() {
	elog "Note that this requires additional configuration of your irssi client. See"
	elog "    ${ROOT}usr/share/doc/${P}/README.md.bz2'"
	elog "for instructions."
}
