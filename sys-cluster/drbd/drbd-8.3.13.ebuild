# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils multilib versionator udev

LICENSE="GPL-2"

DESCRIPTION="mirror/replicate block-devices across a network-connection"
SRC_URI="http://oss.linbit.com/drbd/$(get_version_component_range 1-2 ${PV})/${P}.tar.gz"
HOMEPAGE="http://www.drbd.org"

KEYWORDS="amd64 x86"
IUSE="bash-completion heartbeat pacemaker +udev xen"
SLOT="0"

src_prepare() {
	# respect LDFLAGS
	sed -i -e "s/\$(CC) -o/\$(CC) \$(LDFLAGS) -o/" user/Makefile.in || die
	# respect multilib
	sed -i -e "s:/lib/:/$(get_libdir)/:g" \
		Makefile.in scripts/{Makefile.in,global_common.conf,drbd.conf.example} || die
	sed -e "s:@prefix@/lib:@prefix@/$(get_libdir):" \
		-e "s:(DESTDIR)/lib:(DESTDIR)/$(get_libdir):" \
		-i user/Makefile.in || die
	# correct install paths
	sed -e "s:\$(sysconfdir)/bash_completion.d:/usr/share/bash-completion:" \
		-e "s:\$(sysconfdir)/udev:$(get_udevdir):g" \
		-i scripts/Makefile.in || die
	# don't participate in user survey bug 360483
	sed -i -e '/usage-count/ s/yes/no/' scripts/drbd.conf.example || die
}

src_configure() {
	econf \
		--localstatedir=/var \
		--with-utils \
		--without-km \
		--without-rgmanager \
		$(use_with udev) \
		$(use_with xen) \
		$(use_with pacemaker) \
		$(use_with heartbeat) \
		$(use_with bash-completion bashcompletion) \
		--with-distro=gentoo
}

src_compile() {
	# only compile the tools
	emake OPTFLAGS="${CFLAGS}" tools
}

src_install() {
	# only install the tools
	emake DESTDIR="${D}" install-tools
	dodoc README ChangeLog

	# install our own init script
	newinitd "${FILESDIR}"/${PN}-8.0.rc ${PN}

	dodoc scripts/drbd.conf.example
}

pkg_postinst() {
	einfo
	einfo "Please copy and gunzip the configuration file:"
	einfo "from /usr/share/doc/${PF}/${PN}.conf.example.bz2 to /etc/${PN}.conf"
	einfo "and edit it to your needs. Helpful commands:"
	einfo "man 5 drbd.conf"
	einfo "man 8 drbdsetup"
	einfo "man 8 drbdadm"
	einfo "man 8 drbddisk"
	einfo "man 8 drbdmeta"
	einfo

	elog "Remember to enable drbd support in kernel."
}
