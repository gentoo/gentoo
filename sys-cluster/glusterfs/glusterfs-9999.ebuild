# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit autotools elisp-common python-single-r1 systemd user

if [[ ${PV#9999} != ${PV} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/gluster/glusterfs.git"
else
	SRC_URI="https://download.gluster.org/pub/gluster/${PN}/$(ver_cut '1-2')/${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
fi

DESCRIPTION="GlusterFS is a powerful network/cluster filesystem"
HOMEPAGE="https://www.gluster.org/"

LICENSE="|| ( GPL-2 LGPL-3+ )"
SLOT="0"
IUSE="bd-xlator crypt-xlator debug emacs +fuse +georeplication glupy infiniband ipv6 libressl +libtirpc qemu-block rsyslog static-libs +syslog systemtap test +tiering vim-syntax +xml"

REQUIRED_USE="georeplication? ( ${PYTHON_REQUIRED_USE} )
	glupy? ( ${PYTHON_REQUIRED_USE} )
	ipv6? ( libtirpc )"

# the tests must be run as root
RESTRICT="test"

# sys-apps/util-linux is required for libuuid
RDEPEND="bd-xlator? ( sys-fs/lvm2 )
	!elibc_glibc? ( sys-libs/argp-standalone )
	emacs? ( >=app-editors/emacs-23.1:* )
	fuse? ( >=sys-fs/fuse-2.7.0:0 )
	georeplication? ( ${PYTHON_DEPS} )
	infiniband? ( sys-fabric/libibverbs:* sys-fabric/librdmacm:* )
	libtirpc? ( net-libs/libtirpc:= )
	!libtirpc? ( elibc_glibc? ( sys-libs/glibc[rpc(-)] ) )
	qemu-block? ( dev-libs/glib:2 )
	systemtap? ( dev-util/systemtap )
	tiering? ( dev-db/sqlite:3 )
	xml? ( dev-libs/libxml2 )
	sys-libs/readline:=
	dev-libs/libaio
	!libressl? ( dev-libs/openssl:=[-bindist] )
	libressl? ( dev-libs/libressl:= )
	dev-libs/userspace-rcu:=
	net-libs/rpcsvc-proto
	sys-apps/util-linux"
DEPEND="${RDEPEND}
	virtual/acl
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
	"${FILESDIR}/${PN}-3.12.2-poisoned-sysmacros.patch"
	"${FILESDIR}/${PN}-4.1.0-silent_rules.patch"
)

DOCS=( AUTHORS ChangeLog NEWS README.md THANKS )

# Maintainer notes:
# * The build system will always configure & build argp-standalone but it'll never use it
#   if the argp.h header is found in the system. Which should be the case with
#   glibc or if argp-standalone is installed.

pkg_setup() {
	python_setup "python2*"
	python-single-r1_pkg_setup

	# Needed for statedumps
	# https://github.com/gluster/glusterfs/commit/0e50c4b3ea734456c14e2d7a578463999bd332c3
	enewgroup gluster
	enewuser gluster -1 -1 "${EPREFIX}"/var/run/gluster gluster
}

src_prepare() {
	default

	# build rpc-transport and xlators only once as shared libs
	find rpc/rpc-transport xlators -name Makefile.am |
		xargs sed -i 's|.*$(top_srcdir).*\.sym|\0 -shared|' || die

	# fix execution permissions
	chmod +x libglusterfs/src/gen-defaults.py || die

	eautoreconf
}

src_configure() {
	econf \
		--disable-fusermount \
		$(use_enable debug) \
		$(use_enable bd-xlator) \
		$(use_enable crypt-xlator) \
		$(use_enable fuse fuse-client) \
		$(use_enable georeplication) \
		$(use_enable glupy) \
		$(use_enable infiniband ibverbs) \
		$(use_enable qemu-block) \
		$(use_enable static-libs static) \
		$(use_enable syslog) \
		$(use_enable systemtap) \
		$(use_enable test cmocka) \
		$(use_enable tiering) \
		$(use_enable xml xml-output) \
		$(use libtirpc || echo --without-libtirpc) \
		$(use ipv6 && echo --with-ipv6-default) \
		--with-tmpfilesdir="${EPREFIX}"/etc/tmpfiles.d \
		--localstatedir="${EPREFIX}"/var
}

src_compile() {
	default
	use emacs && elisp-compile extras/glusterfs-mode.el
}

src_install() {
	default

	rm \
		"${ED}"/etc/glusterfs/glusterfs-{georep-,}logrotate \
		"${ED}"/etc/glusterfs/gluster-rsyslog-*.conf \
		"${ED}"/usr/share/doc/${PF}/glusterfs{-mode.el,.vim} || die "removing false files failed"

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
	newinitd "${FILESDIR}/glusterd-r3.initd" glusterd
	newconfd "${FILESDIR}/${PN}.confd" glusterfsd

	keepdir /var/log/${PN}
	keepdir /var/lib/glusterd/{events,glusterfind/.keys}

	# QA
	rm -r "${ED}/var/run/" || die
	if ! use static-libs; then
		find "${D}" -type f -name '*.la' -delete || die
	fi

	# fix all shebang for python2 #560750
	python_fix_shebang "${ED}"
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
	echo
	elog "If you are upgrading from a previous version of ${PN}, please read:"
	elog "  http://docs.gluster.org/en/latest/Upgrade-Guide/upgrade_to_$(ver_cut '1-2')/"

	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
