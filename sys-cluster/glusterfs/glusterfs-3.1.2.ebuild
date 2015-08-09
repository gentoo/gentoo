# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

inherit autotools elisp-common eutils multilib versionator

DESCRIPTION="GlusterFS is a powerful network/cluster filesystem"
HOMEPAGE="http://www.gluster.org/"
SRC_URI="http://ftp.gluster.com/pub/gluster/${PN}/$(get_version_component_range '1-2')/${PV}/${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="emacs extras +fuse infiniband static-libs vim-syntax"

RDEPEND="emacs? ( virtual/emacs )
		fuse? ( >=sys-fs/fuse-2.7.0 )
		infiniband? ( sys-infiniband/libibverbs )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/bison
	sys-devel/flex"

SITEFILE="50${PN}-mode-gentoo.el"

src_prepare() {
	epatch "${FILESDIR}/${PN}-3.1.0-parallel-build.patch" \
		"${FILESDIR}/${PN}-docdir.patch" \
		"${FILESDIR}/glusterd-workdir.patch"
	sed -i -e "s/ -ggdb3//g" argp-standalone/configure.ac || die
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable fuse fuse-client) \
		$(use_enable infiniband ibverbs) \
		$(use_enable static-libs static) \
		--disable-bdb \
		--docdir=/usr/share/doc/${PF} \
		--localstatedir=/var
}

src_compile() {
	emake || die
	if use emacs ; then
		elisp-compile extras/glusterfs-mode.el || die
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die

	if use emacs ; then
		elisp-install ${PN} extras/glusterfs-mode.el* || die
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi

	if use vim-syntax ; then
		insinto /usr/share/vim/vimfiles/ftdetect; doins "${FILESDIR}/glusterfs.vim" || die
		insinto /usr/share/vim/vimfiles/syntax; doins extras/glusterfs.vim || die
	fi

	if use extras ; then
		newbin extras/volgen/glusterfs-volgen glusterfs-volgen || die
		newbin extras/backend-xattr-sanitize.sh glusterfs-backend-xattr-sanitize || die
		newbin extras/migrate-unify-to-distribute.sh glusterfs-migrate-unify-to-distribute || die
	fi

	dodoc AUTHORS ChangeLog NEWS README THANKS || die

	newinitd "${FILESDIR}/${PN}.initd" glusterfsd || die
	newinitd "${FILESDIR}/glusterd.initd" glusterd || die
	newconfd "${FILESDIR}/${PN}.confd" glusterfsd || die

	keepdir /var/log/${PN} || die
	keepdir /var/lib/glusterd || die
}

pkg_postinst() {
	elog "Starting with ${PN}-3.1.0, you can use the glusterd daemon to configure your"
	elog "volumes dynamically. To do so, simply use the gluster CLI after running:"
	elog "  /etc/init.d/glusterd start"
	elog
	elog "For static configurations, the glusterfsd startup script can be multiplexed."
	elog "The default startup script uses /etc/conf.d/glusterfsd to configure the"
	elog "separate service.  To create additional instances of the glusterfsd service"
	elog "simply create a symlink to the glusterfsd startup script."
	elog
	elog "Example:"
	elog "    # ln -s glusterfsd /etc/init.d/glusterfsd2"
	elog "    # ${EDITOR} /etc/glusterfs/glusterfsd2.vol"
	elog "You can now treat glusterfsd2 like any other service"
	elog
	elog "For more information on how to mount exported GlusterFS filesystems visit:"
	elog "http://www.gluster.org/docs/index.php/Mounting_a_GlusterFS_Volume"
	elog
	elog "If you are upgrading from glusterfs 3.0.x please read:"
	elog "http://www.gluster.com/community/documentation/index.php/Gluster_3.0_to_3.1_Upgrade_Guide"
	elog
	ewarn "You need to use a ntp client to keep the clocks synchronized across all"
	ewarn "of your servers.  Setup a NTP synchronizing service before attempting to"
	ewarn "run GlusterFS."

	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
