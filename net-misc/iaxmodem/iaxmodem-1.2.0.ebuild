# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils toolchain-funcs multilib

DESCRIPTION="Software modem that uses an IAX channel instead of a traditional phone line"
HOMEPAGE="http://sourceforge.net/projects/iaxmodem/"
SRC_URI="mirror://sourceforge/iaxmodem/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

RDEPEND="media-libs/tiff
	sys-process/procps"

DEPEND="${RDEPEND}
	sys-apps/sed"

src_prepare() {
	# fix header file position
	sed -i -e 's:iax/iax-client\.h:iax-client.h:g' iaxmodem.c

	# fix broken line terminators
	sed -i -e 's:\r::g' -e 's:--s$:--:g' -e 's:$:\r:g' iaxmodem.inf

	# fix installation of libiax2 headers (though we don't need them)
	sed -i -e 's: \(\$(includedir)/\): $(DESTDIR)\1:g' lib/libiax2/src/Makefile.in

	# patch configure (we compile libs for ourself)
	sed -i -e 's:^\(cd\|./configure\):# \1:g' configure
	sed -i -e 's:build-libiax build-libspandsp ::g' Makefile.in

	# fix dumb x86_64 libdir handling
	sed -i -e 's: \(x86_64-\*)\): _DISABLED_\1:g' lib/spandsp/configure
}

src_configure() {
	cd "${S}/lib/libiax2"
	econf --disable-static \
		--libdir=/usr/$(get_libdir)/iaxmodem \
		--datadir=/usr/share/iaxmodem/libiax2 || die "econf libiax2 failed"

	cd "${S}/lib/spandsp"
	econf --disable-static \
		--libdir=/usr/$(get_libdir)/iaxmodem \
		--datadir=/usr/share/iaxmodem || die "econf spandsp failed"

	cd "${S}"
	./configure || die "configure iaxmodem failed"
}

src_compile() {
	cd "${S}/lib/libiax2"
	emake || die "emake libiax2 failed"

	cd "${S}/lib/spandsp"
	emake || die "emake spandsp failed"

	cd "${S}"
	emake OBJS="iaxmodem.o" CC=$(tc-getCC) \
		LDFLAGS="${LDFLAGS} -Wl,-rpath,/usr/$(get_libdir)/iaxmodem \
			-Llib/spandsp/src/.libs -Llib/libiax2/src/.libs -lm -lutil -ltiff -lspandsp -liax" \
	|| die "emake iaxmodem failed"
}

src_install() {
	cd "${S}/lib/libiax2"
	emake DESTDIR="${D}" install || die "install libiax2 failed"

	cd "${S}/lib/spandsp"
	emake DESTDIR="${D}" install || die "install spandsp failed"

	cd "${S}"
	dosbin iaxmodem || die "install failed"

	# remove libiax and spandsp headers, we don't need them
	rm -rf "${D}usr/include" "${D}usr/bin/iax-config"

	# install init-script + conf
	newinitd "${FILESDIR}/iaxmodem.initd" iaxmodem
	newconfd "${FILESDIR}/iaxmodem.confd" iaxmodem

	# install docs
	doman iaxmodem.1
	newdoc CHANGES ChangeLog
	newdoc lib/libiax2/ChangeLog ChangeLog.libiax2
	newdoc lib/spandsp/ChangeLog ChangeLog.spandsp
	dodoc FAQ README lib/spandsp/DueDiligence

	# install sample configs
	insinto /etc/iaxmodem
	newins "${FILESDIR}/iaxmodem.cfg" default
	insinto /usr/share/iaxmodem
	doins config.ttyIAX iaxmodem-cfg.ttyIAX iaxmodem.inf

	# install logrotate rule
	insinto /etc/logrotate.d
	newins "${FILESDIR}/iaxmodem.logrotated" iaxmodem

	# create log dir
	keepdir /var/log/iaxmodem
}
