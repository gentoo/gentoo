# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

DESCRIPTION="Advanced CLI tool for sending email"
HOMEPAGE="http://email.cleancode.org"
SRC_URI="http://email.cleancode.org/download/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="alpha amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_compile() {
	local myconf=""

	if [ -f /etc/conf.d/clock ]; then
		. /etc/conf.d/clock
		if [ x$CLOCK = "xUTC" ]; then
			elog "Using UTC timestamps (from /etc/conf.d/clock)"
			myconf="${myconf} --with-utc"
		fi
	fi

	sed -i -e "s:/doc/email-\${version}:/share/doc:" configure
	sed -i -e "s:DIVIDER = '---':DIVIDER = '-- ':" email.conf

	econf ${myconf} || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	doman email.1
	dodoc INSTALL quoted-printable.rfc RFC821 TODO
	make DESTDIR="${D}" install || die "install failed"
}

pkg_preinst() {
	rm "${D}"/usr/share/doc/"${P}"/email.1
}

pkg_postinst() {
	echo
	elog "Do not forget to edit /etc/email/email.conf file before using email."
	echo
}
