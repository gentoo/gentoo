# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils multilib

DESCRIPTION="An automated suite of programs for configuring and maintaining
Unix-like computers"
HOMEPAGE="http://www.cfengine.org/"
SRC_URI="http://cfengine.com/source_code/download?file=${P}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ppc ppc64 ~s390 sparc x86"
IUSE="vim-syntax"

RDEPEND=">=sys-libs/db-4
	>=dev-libs/openssl-0.9.7
	app-portage/portage-utils"
DEPEND="${RDEPEND}
	virtual/yacc
	sys-devel/flex"
PDEPEND="vim-syntax? ( app-vim/cfengine-syntax )"

src_prepare() {
	# http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=520696
	# http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=511666
	# https://bugs.gentoo.org/339808
	epatch "${FILESDIR}/admit-noclass-520696.patch" \
		"${FILESDIR}/511666-segfault.patch" \
		"${FILESDIR}/${P}-snprintf_buffer_overflow.patch"

	# 2048 causes crashes on some 32-bit hardened kernels, and the warning
	# messages say to turn it back down.
	use x86 && sed -ie "s:CF_IFREQ 2048:CF_IFREQ 1024:g" src/cf.defs.h
}

src_configure() {
	# Enforce /var/cfengine for historical compatibility
	econf \
		--with-workdir=/var/cfengine \
		--with-berkeleydb=/usr

	# Fix Makefile to skip doc,inputs, & contrib install to wrong locations
	sed -i -e 's/\(DIST_SUBDIRS.*\) contrib inputs doc/\1/' Makefile
	sed -i -e 's/\(SUBDIRS.*\) contrib inputs/\1/' Makefile
	sed -i -e 's/\(install-data-am.*\) install-docDATA/\1/' Makefile

	# Fix man pages
	sed -i -e 's/\/usr\/local/\/usr/' doc/*.8
}

src_install() {
	newinitd "${FILESDIR}"/cfservd.rc6 cfservd || die
	newinitd "${FILESDIR}"/cfenvd.rc6 cfenvd || die
	newinitd "${FILESDIR}"/cfexecd.rc6 cfexecd || die

	make DESTDIR="${D}" install || die

	# Remove static library and libtool file as they are not needed
	rm "${D}"/usr/$(get_libdir)/*.la
	rm "${D}"/usr/$(get_libdir)/*.a

	dodoc AUTHORS ChangeLog README TODO INSTALL

	# Manually install doc and inputs
	doman doc/*.8
	docinto examples
	doinfo doc/*.info*
	dodoc inputs/*.example

	# Create cfengine working directory
	mkdir -p "${D}"/var/cfengine
	fperms 700 /var/cfengine
	keepdir /var/cfengine/bin
	keepdir /var/cfengine/inputs
	dodir /var/cfengine/modules
}

pkg_postinst() {
	# Copy cfagent into the cfengine tree otherwise cfexecd won't
	# find it. Most hosts cache their copy of the cfengine
	# binaries here. This is the default search location for the
	# binaries.

	cp -f /usr/sbin/cf{agent,servd,execd} "${ROOT}"/var/cfengine/bin/

	einfo
	einfo "NOTE: The cfportage module has been deprecated in favor of the"
	einfo "      upstream 'packages' action."
	einfo
	einfo "Init scripts for cfservd, cfenvd, and cfexecd are now provided."
	einfo
	einfo "To run cfengine out of cron every half hour modify your crontab:"
	einfo "0,30 * * * *    /usr/sbin/cfexecd -F"
	einfo

	elog "You MUST generate the keys for cfengine by running:"
	elog "emerge --config ${CATEGORY}/${PN}"
}

pkg_config() {
	if [ "${ROOT}" == "/" ]; then
		if [ ! -f "/var/cfengine/ppkeys/localhost.priv" ]; then
			einfo "Generating keys for localhost."
			/usr/sbin/cfkey
		fi
	else
		die "cfengine cfkey does not support any value of ROOT other than /."
	fi
}
