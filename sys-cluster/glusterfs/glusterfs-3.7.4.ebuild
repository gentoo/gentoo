# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
AUTOTOOLS_AUTORECONF=1

inherit autotools-utils elisp-common eutils multilib python-single-r1 systemd versionator

DESCRIPTION="GlusterFS is a powerful network/cluster filesystem"
HOMEPAGE="http://www.gluster.org/"
SRC_URI="http://download.gluster.org/pub/gluster/${PN}/$(get_version_component_range '1-2')/${PV}/${P}.tar.gz"

LICENSE="|| ( GPL-2 LGPL-3+ )"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="bd-xlator crypt-xlator debug emacs +fuse +georeplication glupy infiniband qemu-block rsyslog static-libs +syslog systemtap test +tiering vim-syntax +xml"

REQUIRED_USE="georeplication? ( ${PYTHON_REQUIRED_USE} )
	glupy? ( ${PYTHON_REQUIRED_USE} )"

# the tests must be run as root
RESTRICT="test"

# sys-apps/util-linux is required for libuuid
RDEPEND="bd-xlator? ( sys-fs/lvm2 )
	emacs? ( virtual/emacs )
	fuse? ( >=sys-fs/fuse-2.7.0 )
	georeplication? ( ${PYTHON_DEPS} )
	infiniband? ( sys-fabric/libibverbs:* sys-fabric/librdmacm:* )
	qemu-block? ( dev-libs/glib:2 )
	systemtap? ( dev-util/systemtap )
	tiering? ( dev-db/sqlite:3 )
	xml? ( dev-libs/libxml2 )
	sys-libs/readline:=
	dev-libs/libaio
	dev-libs/openssl:=[-bindist]
	dev-libs/userspace-rcu:=
	|| ( sys-libs/glibc sys-libs/argp-standalone )
	sys-apps/util-linux"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/bison
	sys-devel/flex
	test? ( >=dev-util/cmocka-1.0.1
		app-benchmarks/dbench
		dev-vcs/git
		net-fs/nfs-utils
		virtual/perl-Test-Harness
		dev-libs/yajl
		sys-fs/xfsprogs
		sys-apps/attr )"

SITEFILE="50${PN}-mode-gentoo.el"

PATCHES=(
	"${FILESDIR}/${PN}-3.4.0-silent_rules.patch"
)

DOCS=( AUTHORS ChangeLog NEWS README.md THANKS )

# Maintainer notes:
# * The build system will always configure & build argp-standalone but it'll never use it
#   if the argp.h header is found in the system. Which should be the case with
#   glibc or if argp-standalone is installed.

pkg_setup() {
	( use georeplication || use glupy ) && python-single-r1_pkg_setup
}

src_prepare() {
	# build rpc-transport and xlators only once as shared libs
	find rpc/rpc-transport xlators -name Makefile.am -print0 \
		| xargs -0 sed -i -e 's|.*_la_LDFLAGS = .*|\0 -shared|'

	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--disable-dependency-tracking
		--disable-silent-rules
		--disable-fusermount
		$(use_enable debug)
		$(use_enable bd-xlator)
		$(use_enable crypt-xlator)
		$(use_enable fuse fuse-client)
		$(use_enable georeplication)
		$(use_enable glupy)
		$(use_enable infiniband ibverbs)
		$(use_enable qemu-block)
		$(use_enable static-libs static)
		$(use_enable syslog)
		$(use_enable systemtap)
		$(use_enable test cmocka)
		$(use_enable tiering)
		$(use_enable xml xml-output)
		--docdir=/usr/share/doc/${PF}
		--localstatedir=/var
	)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile

	use emacs && elisp-compile extras/glusterfs-mode.el
}

src_install() {
	autotools-utils_src_install

	rm \
		"${D}"/etc/glusterfs/glusterfs-{georep-,}logrotate \
		"${D}"/etc/glusterfs/gluster-rsyslog-*.conf \
		"${D}"/usr/share/doc/${PF}/glusterfs{-mode.el,.vim} || die "removing false files failed"

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/glusterfs.logrotate glusterfs

	if use rsyslog ; then
		insinto /etc/rsyslog.d
		newins extras/gluster-rsyslog-7.2.conf 60-gluster.conf
	fi

	if use emacs ; then
		elisp-install ${PN} extras/glusterfs-mode.el*
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi

	if use vim-syntax ; then
		insinto /usr/share/vim/vimfiles/ftdetect; doins "${FILESDIR}"/${PN}.vim
		insinto /usr/share/vim/vimfiles/syntax; doins extras/${PN}.vim
	fi

	# insert some other tools which might be useful
	insinto /usr/share/glusterfs/scripts
	doins \
		extras/backend-{cleanup,xattr-sanitize}.sh \
		extras/clear_xattrs.sh \
		extras/migrate-unify-to-distribute.sh

	# correct permissions on installed scripts
	# fperms 0755 /usr/share/glusterfs/scripts/*.sh
	chmod 0755 "${ED}"/usr/share/glusterfs/scripts/*.sh || die

	if use georeplication ; then
		# move the gsync-sync-gfid tool to a binary path
		# and set a symlink to be compliant with all other distros
		mv "${ED}"/usr/{share/glusterfs/scripts/gsync-sync-gfid,libexec/glusterfs/} || die
		dosym ../../../libexec/glusterfs/gsync-sync-gfid /usr/share/glusterfs/scripts/gsync-sync-gfid
	fi

	newinitd "${FILESDIR}/${PN}-r1.initd" glusterfsd
	newinitd "${FILESDIR}/glusterd-r2.initd" glusterd
	newconfd "${FILESDIR}/${PN}.confd" glusterfsd

	keepdir /var/log/${PN}
	keepdir /var/lib/glusterd

	# QA
	rm -rf "${ED}/var/run/" || die
	use static-libs || find "${ED}"/usr/$(get_libdir)/ -type f -name '*.la' -delete

	use georeplication && python_fix_shebang "${ED}"

	# upstream already has a patch ready, to be removed once available, http://review.gluster.org/#/c/9458/
	echo "d /run/gluster 0755 root root -" > "${T}/gluster.tmpfiles" || die
	systemd_newtmpfilesd "${T}/gluster.tmpfiles" gluster.conf
}

src_test() {
	./run-tests.sh || die
}

pkg_postinst() {
	elog "Starting with ${PN}-3.1.0, you can use the glusterd daemon to configure your"
	elog "volumes dynamically. To do so, simply use the gluster CLI after running:"
	elog "  /etc/init.d/glusterd start"
	echo
	elog "For static configurations, the glusterfsd startup script can be multiplexed."
	elog "The default startup script uses /etc/conf.d/glusterfsd to configure the"
	elog "separate service.  To create additional instances of the glusterfsd service"
	elog "simply create a symlink to the glusterfsd startup script."
	echo
	elog "Example:"
	elog "    # ln -s glusterfsd /etc/init.d/glusterfsd2"
	elog "    # ${EDITOR} /etc/glusterfs/glusterfsd2.vol"
	elog "You can now treat glusterfsd2 like any other service"
	echo
	ewarn "You need to use a ntp client to keep the clocks synchronized across all"
	ewarn "of your servers. Setup a NTP synchronizing service before attempting to"
	ewarn "run GlusterFS."

	elog
	elog "If you are upgrading from a previous version of ${PN}, please read:"
	elog "  http://www.gluster.org/community/documentation/index.php/Upgrade_to_3.5"

	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
