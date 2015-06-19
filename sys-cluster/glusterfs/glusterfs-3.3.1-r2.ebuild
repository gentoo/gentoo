# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/glusterfs/glusterfs-3.3.1-r2.ebuild,v 1.2 2014/08/11 22:28:30 blueness Exp $

EAPI=4

PYTHON_DEPEND="2"
AUTOTOOLS_AUTORECONF=1

inherit autotools-utils elisp-common eutils multilib python versionator

DESCRIPTION="GlusterFS is a powerful network/cluster filesystem"
HOMEPAGE="http://www.gluster.org/"
SRC_URI="http://download.gluster.org/pub/gluster/${PN}/$(get_version_component_range '1-2')/${PV}/${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="emacs extras +fuse infiniband static-libs vim-syntax"

RDEPEND="emacs? ( virtual/emacs )
	fuse? ( >=sys-fs/fuse-2.7.0 )
	infiniband? ( sys-infiniband/libibverbs )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/bison
	sys-devel/flex"

SITEFILE="50${PN}-mode-gentoo.el"

PATCHES=(
	"${FILESDIR}/${PN}-3.3.0-parallel-build.patch"
	"${FILESDIR}/${PN}-3.3.0-docdir.patch"
	"${FILESDIR}/${PN}-3.3.0-silent_rules.patch"
	"${FILESDIR}/${PN}-3.3.0-avoid-version.patch"
)

DOCS=( AUTHORS ChangeLog NEWS README THANKS )

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	sed -e "s/ -ggdb3//g" \
		-i argp-standalone/configure.ac || die
	sed -e "s:\$(PYTHON):${PREFIX}/usr/bin/python2:g" \
		-i xlators/features/marker/utils/src/Makefile.am || die #446330
	sed -e 's:"/usr/local/libexec/glusterfs:GSYNCD_PREFIX":' \
		-i xlators/mgmt/glusterd/src/glusterd.c || die #464196
	autotools-utils_src_prepare
	cd argp-standalone && eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-dependency-tracking
		--disable-silent-rules
		$(use_enable fuse fuse-client)
		$(use_enable infiniband ibverbs)
		$(use_enable static-libs static)
		--enable-georeplication
		--docdir=/usr/share/doc/${PF}
		--localstatedir=/var
	)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile
	if use emacs ; then
		elisp-compile extras/glusterfs-mode.el || die
	fi
}

src_install() {
	autotools-utils_src_install

	if use emacs ; then
		elisp-install ${PN} extras/glusterfs-mode.el* || die
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi

	if use vim-syntax ; then
		insinto /usr/share/vim/vimfiles/ftdetect; doins "${FILESDIR}"/${PN}.vim
		insinto /usr/share/vim/vimfiles/syntax; doins extras/${PN}.vim
	fi

	if use extras ; then
		newbin extras/backend-xattr-sanitize.sh ${PN}-backend-xattr-sanitize
		newbin extras/backend-cleanup.sh ${PN}-backend-cleanup
		newbin extras/migrate-unify-to-distribute.sh ${PN}-migrate-unify-to-distribute
		newbin extras/disk_usage_sync.sh ${PN}-disk-usage-sync
	fi

	newinitd "${FILESDIR}/${PN}-r1.initd" glusterfsd
	newinitd "${FILESDIR}/glusterd.initd" glusterd
	newconfd "${FILESDIR}/${PN}.confd" glusterfsd

	keepdir /var/log/${PN}
	keepdir /var/lib/glusterd

	python_convert_shebangs -r 2 "${ED}"
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
	ewarn "You need to use a ntp client to keep the clocks synchronized across all"
	ewarn "of your servers. Setup a NTP synchronizing service before attempting to"
	ewarn "run GlusterFS."

	elog
	elog "You are upgrading from a previous version of ${PN}, please read:"
	elog "http://vbellur.wordpress.com/2012/05/31/upgrading-to-glusterfs-3-3/"

	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
