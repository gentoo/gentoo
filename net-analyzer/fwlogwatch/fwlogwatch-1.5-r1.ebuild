# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic strip-linguas toolchain-funcs

DESCRIPTION="A packet filter and firewall log analyzer"
HOMEPAGE="http://fwlogwatch.inside-security.de/"
SRC_URI="http://fwlogwatch.inside-security.de/sw/${P}.tar.bz2"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"
IUSE="geoip nls zlib"

RDEPEND="
	virtual/libcrypt:=
	geoip? ( dev-libs/geoip )
	zlib? ( sys-libs/zlib )
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/flex
	nls? ( sys-devel/gettext )
"

src_prepare() {
	default

	if use nls; then
		strip-linguas -i po/
		local lingua pofile
		for pofile in po/*.po; do
			lingua=${pofile/po\/}
			lingua=${lingua/.po}
			if ! has ${lingua} ${LINGUAS}; then
				sed -i \
					-e "/${lingua}.[mp]o/d" \
					Makefile po/Makefile || die
			fi
		done
	fi

	sed -i \
		-e '/^INSTALL_/s|$| -D|g' \
		-e 's|make|$(MAKE)|g ' \
		Makefile || die
}

src_configure() {
	if ! use zlib; then
		sed -i Makefile -e '/^LIBS/ s|-lz||g' || die
	else
		append-cflags -DHAVE_ZLIB
	fi

	if use geoip; then
		append-cflags -DHAVE_GEOIP
		sed -i Makefile -e '/^LIBS/ s| #| -lGeoIP #|g' || die
	fi

	use nls && append-cflags -DHAVE_GETTEXT
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}"
	use nls && emake -C po
}

src_install() {
	emake \
		LOCALE_DIR="${D}/usr" INSTALL_DIR="${D}/usr" \
		install

	use nls && emake \
		LOCALE_DIR="${D}/usr" INSTALL_DIR="${D}/usr" \
		install-i18n

	dosbin contrib/fwlw_notify
	dosbin contrib/fwlw_respond

	dodoc AUTHORS ChangeLog CREDITS README

	insinto /usr/share/fwlogwatch/contrib

	doins contrib/fwlogsummary.cgi
	doins contrib/fwlogsummary_small.cgi
	doins contrib/fwlogwatch.php

	insinto /etc
	doins fwlogwatch.config
}
