# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

# https://github.com/phhusson/quassel-irssi/pull/10 if accepted will
# allow QuasselC to be installed as a separate package.

# Commit Date: Sat, 7 Jan 2017 14:50:15 +0000
COMMIT="f23e97a6188129cfae4c52f7e1a75940185454f4"

DESCRIPTION="Irssi module to connect to Quassel cores."
HOMEPAGE="https://github.com/phhusson/quassel-irssi/"
SRC_URI="https://github.com/phhusson/${PN}/archive/${COMMIT}.zip -> ${PF}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# fails to build with irssi-1.0
RDEPEND="<=net-irc/irssi-0.8.21"
DEPEND="${RDEPEND}
	net-libs/quasselc"

S="${WORKDIR}/${PN}-${COMMIT}"

src_prepare() {
	default

	sed -e "s:pkg-config:$(tc-getPKG_CONFIG):" \
		-e 's:^CFLAGS=.*:CFLAGS+=$(IRSSI_CFLAGS) $(QUASSELC_FLAGS):' \
		-i "${S}/core/Makefile" || die

	sed -e 's:gcc -shared:$(CC) -shared:' -i "${S}/core/Makefile" || die

	tc-export CC
	export SYSTEM_QUASSELC=1
}

src_compile() {
	emake IRSSI_LIB="${ROOT}usr/$(get_libdir)/irssi" -C core
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
