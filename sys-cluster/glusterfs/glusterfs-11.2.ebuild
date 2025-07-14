# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..14} )

inherit autotools elisp-common python-single-r1 tmpfiles systemd bash-completion-r1

DESCRIPTION="GlusterFS is a powerful network/cluster filesystem"
HOMEPAGE="https://www.gluster.org/ https://github.com/gluster/glusterfs/"
SRC_URI="https://github.com/gluster/glusterfs/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( GPL-2 LGPL-3+ )"
SLOT="0/${PV%%.*}"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"

IUSE="debug emacs +fuse georeplication ipv6 +libtirpc rsyslog selinux static-libs tcmalloc test +uring xml"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	georeplication? ( xml )
	ipv6? ( libtirpc )"

# the tests must be run as root
RESTRICT="test"

PATCHES=(
	"${FILESDIR}/${PN}-11.0-extras-defer-invoking-of-gluster-volume-set-help-as-.patch"
)

# sys-apps/util-linux is required for libuuid
RDEPEND="
	acct-group/gluster
	acct-user/gluster
	dev-libs/libaio
	dev-libs/openssl:=[-bindist(-)]
	net-libs/rpcsvc-proto
	dev-libs/userspace-rcu:=
	sys-apps/util-linux
	sys-libs/readline:=
	${PYTHON_DEPS}

	!elibc_glibc? ( sys-libs/argp-standalone )
	emacs? ( >=app-editors/emacs-23.1:* )
	fuse? ( >=sys-fs/fuse-2.7.0:0 )
	libtirpc? ( net-libs/libtirpc:= )
	!libtirpc? ( elibc_glibc? ( sys-libs/glibc[rpc(-)] ) )
	selinux? ( sec-policy/selinux-glusterfs )
	tcmalloc? ( dev-util/google-perftools )
	uring? ( sys-libs/liburing:= )
	xml? ( dev-libs/libxml2:= )
"
DEPEND="
	${RDEPEND}
	virtual/acl
	test? (
		>=dev-util/cmocka-1.0.1
		app-benchmarks/dbench
		dev-libs/xxhash
		dev-vcs/git
		dev-libs/yajl
		sys-fs/xfsprogs
		sys-apps/attr
	)
"
BDEPEND="
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
"

DOCS=( AUTHORS ChangeLog NEWS README.md THANKS )

# Maintainer notes:
# * The build system will always configure & build argp-standalone but it'll never use it
#   if the argp.h header is found in the system. Which should be the case with
#   glibc or if argp-standalone is installed.

pkg_setup() {
	python_setup "python3*"
	python-single-r1_pkg_setup
}

src_prepare() {
	default

	# build rpc-transport and xlators only once as shared libs
	find rpc/rpc-transport xlators -name Makefile.am -exec \
		sed -i 's|.*$(top_srcdir).*\.sym|\0 -shared|' {} + || die

	# fix execution permissions
	chmod +x libglusterfs/src/gen-defaults.py || die

	eautoreconf
}

src_configure() {
	econf \
		YACC=yacc.bison \
		LEX=flex \
		--disable-fusermount \
		--disable-lto \
		$(use_enable debug) \
		$(use_enable fuse fuse-client) \
		$(use_enable georeplication) \
		$(use_enable static-libs static) \
		$(use_enable test cmocka) \
		$(use_enable uring linux-io_uring) \
		$(use_enable xml xml-output) \
		$(usex ipv6 --with-ipv6-default "") \
		$(usex libtirpc "" --without-libtirpc) \
		$(usex tcmalloc "" --without-tcmalloc) \
		--with-tmpfilesdir="${EPREFIX}"/usr/lib/tmpfiles.d \
		--localstatedir="${EPREFIX}"/var
}

src_compile() {
	default
	use emacs && elisp-compile extras/glusterfs-mode.el
}

src_test() {
	./run-tests.sh || die
}

src_install() {
	default

	# Path changes based on whether app-shells/bash-completion is installed, bug #911523
	rm -rf "${ED}"/etc/bash_completion.d "${D}$(get_bashcompdir)" || die
	newbashcomp extras/command-completion/gluster.bash gluster

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
		elisp-site-file-install "${FILESDIR}/50glusterfs-mode-gentoo.el"
	fi

	insinto /usr/share/vim/vimfiles/ftdetect; doins "${FILESDIR}"/${PN}.vim
	insinto /usr/share/vim/vimfiles/syntax; doins extras/${PN}.vim

	# insert some other tools which might be useful
	insinto /usr/share/glusterfs/scripts
	doins \
		extras/backend-{cleanup,xattr-sanitize}.sh \
		extras/clear_xattrs.sh \
		extras/migrate-unify-to-distribute.sh

	# correct permissions on installed scripts
	# fperms 0755 /usr/share/glusterfs/scripts/*.sh
	chmod 0755 "${ED}"/usr/share/glusterfs/scripts/*.sh || die

	newinitd "${FILESDIR}/glusterfsd-10.2.initd" glusterfsd
	newinitd "${FILESDIR}/glusterd-10.2-r2.initd" glusterd
	newconfd "${FILESDIR}/${PN}.confd" glusterfsd

	keepdir /var/log/${PN}
	keepdir /var/lib/glusterd/{events,glusterfind/.keys}

	systemd_dounit extras/systemd/{glusterd,glustereventsd,glusterfssharedstorage,gluster-ta-volume}.service

	# QA
	rm -r "${ED}/var/run/" || die
	if ! use static-libs; then
		find "${D}" -type f -name '*.la' -delete || die
	fi

	python_fix_shebang "${ED}"
	python_optimize
}

pkg_postinst() {
	tmpfiles_process gluster.conf

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
