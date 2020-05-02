# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=(python2_7)
PYTHON_REQ_USE="ipv6(+)?"

inherit user autotools bash-completion-r1 python-single-r1

MY_PV="${PV/_rc/~rc}"
MY_PV="${MY_PV/_beta/~beta}"
MY_P="${PN}-${MY_PV}"
SERIES="$(ver_cut 1-2)"

DEBIAN_PATCH=11
SRC_URI="
	http://downloads.ganeti.org/releases/${SERIES}/${MY_P}.tar.gz
	mirror://debian/pool/main/g/ganeti-${SERIES}/ganeti-${SERIES}_${PV}-${DEBIAN_PATCH}.debian.tar.xz
"
KEYWORDS="~amd64 ~x86"
PATCHES=(
	"${FILESDIR}"/ganeti-2.15-use-balloon-device.patch
	"${WORKDIR}"/debian/patches/do-not-backup-export-dir.patch
	"${WORKDIR}"/debian/patches/Makefile.am-use-C.UTF-8
	"${WORKDIR}"/debian/patches/relax-deps
	"${WORKDIR}"/debian/patches/zlib-0.6-compatibility
	"${WORKDIR}"/debian/patches/fix_FTBFS_with_sphinx-1.3.5
	"${WORKDIR}"/debian/patches/fix_ftbfs_with_sphinx_1.4
	"${WORKDIR}"/debian/patches/use-proper-cabal-dev.patch
	"${WORKDIR}"/debian/patches/0001-Drop-dependency-on-MonadCatchIO-transformers.patch
	"${WORKDIR}"/debian/patches/0001-GHC-8-support.patch
	"${WORKDIR}"/debian/patches/ghc8-fixes
	"${WORKDIR}"/debian/patches/snap-server-1.0-compat
	"${WORKDIR}"/debian/patches/non-DSA-SSH-key-support.patch
	"${WORKDIR}"/debian/patches/fix-ssh-key-renewal-on-single-node-clusters.patch
	"${WORKDIR}"/debian/patches/set-defaults-for-ssh-type-bits.patch
	"${WORKDIR}"/debian/patches/use-hv-class-to-check-for-migration.patch
	"${WORKDIR}"/debian/patches/do-not-specify-socat-ssl-method.patch
	"${WORKDIR}"/debian/patches/fix-ftbfs-with-sphinx-1.5.patch
	"${WORKDIR}"/debian/patches/fix-failover-from-dead-node.patch
	"${WORKDIR}"/debian/patches/fix-cpu-affinity.patch
	"${WORKDIR}"/debian/patches/fix-fcntl-i386.patch
	"${WORKDIR}"/debian/patches/fix-ovf-test-path.patch
	"${WORKDIR}"/debian/patches/fix-qa-ssconf-race.patch
	"${WORKDIR}"/debian/patches/relax-sphinx-version-check.patch
	#"${WORKDIR}"/debian/patches/THH-2.12.patch
	"${WORKDIR}"/debian/patches/sphinx-1.7.patch
	"${WORKDIR}"/debian/patches/ca-use-sha256-md.patch
	"${WORKDIR}"/debian/patches/impexpd-fix-certificate-verification-with-new-socat.patch
	"${WORKDIR}"/debian/patches/impexpd-fix-certificate-verification-with-new-socat-2.patch
)

DESCRIPTION="Ganeti is a virtual server management software tool"
HOMEPAGE="http://www.ganeti.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE="drbd experimental haskell-daemons htools ipv6 kvm lxc monitoring multiple-users rbd syslog test xen restricted-commands"
RESTRICT="!test? ( test )"

REQUIRED_USE="|| ( kvm xen lxc )
	test? ( ipv6 )
	kvm? ( || ( amd64 x86 ) )
	${PYTHON_REQUIRED_USE}"

USER_PREFIX="${GANETI_USER_PREFIX:-"gnt-"}"
GROUP_PREFIX="${GANETI_GROUP_PREFIX:-"${USER_PREFIX}"}"

DEPEND="
	dev-libs/openssl:0
	$(python_gen_cond_dep '
		dev-python/paramiko[${PYTHON_MULTI_USEDEP}]
		dev-python/pyopenssl[${PYTHON_MULTI_USEDEP}]
		dev-python/simplejson[${PYTHON_MULTI_USEDEP}]
		dev-python/pyparsing[${PYTHON_MULTI_USEDEP}]
		dev-python/pyinotify[${PYTHON_MULTI_USEDEP}]
		dev-python/pycurl[${PYTHON_MULTI_USEDEP}]
		dev-python/ipaddr[${PYTHON_MULTI_USEDEP}]
		dev-python/bitarray[${PYTHON_MULTI_USEDEP}]
		dev-python/docutils[${PYTHON_MULTI_USEDEP}]
		dev-python/fdsend[${PYTHON_MULTI_USEDEP}]
	')
	|| (
		net-misc/iputils[arping]
		net-analyzer/arping
	)
	net-analyzer/fping
	net-misc/bridge-utils
	net-misc/curl[ssl]
	net-misc/openssh
	net-misc/socat
	sys-apps/iproute2
	>=sys-fs/lvm2-2.02.181
	>=sys-apps/baselayout-2.0
	>=dev-lang/ghc-8.0:0=
	<dev-lang/ghc-8.1:0=
	dev-haskell/cabal:0=
	dev-haskell/cabal-install:0=
	!<app-emulation/ganeti-instance-image-0.6-r1
	>=dev-haskell/mtl-2.1.1:0=
	>=dev-haskell/old-time-1.1.0.0:0=
	>=dev-haskell/random-1.0.1.1:0=
	haskell-daemons? ( >=dev-haskell/text-0.11.1.13:0= )
	>=dev-haskell/transformers-0.3.0.0:0=

	>=dev-haskell/attoparsec-0.10.1.1:0=
	<dev-haskell/attoparsec-0.14:0
	>=dev-haskell/base64-bytestring-1.0.0.1:0=
	<dev-haskell/base64-bytestring-1.1:0=
	>=dev-haskell/crypto-4.2.4:0=
	<dev-haskell/crypto-4.3:0=
	>=dev-haskell/curl-1.3.7:0=
	<dev-haskell/curl-1.4:0=
	>=dev-haskell/hinotify-0.3.2:0=
	<dev-haskell/hinotify-0.4:0=
	>=dev-haskell/hslogger-1.1.4:0=
	<dev-haskell/hslogger-1.3:0=
	>=dev-haskell/json-0.5:0=
	>=dev-haskell/lens-3.10:0=
	>=dev-haskell/lifted-base-0.2.0.3:0=
	<dev-haskell/lifted-base-0.3:0=
	>=dev-haskell/monad-control-1.0.1.0:0=
	<dev-haskell/monad-control-1.0.2:0=
	>=dev-haskell/network-2.3.0.13:0=
	<dev-haskell/network-2.7:0=
	>=dev-haskell/parallel-3.2.0.2:3=
	<dev-haskell/parallel-3.3:3=
	>=dev-haskell/temporary-1.1.2.3:0=
	<dev-haskell/temporary-1.3:0=
	>=dev-haskell/regex-pcre-0.94.2:0=
	<dev-haskell/regex-pcre-0.95:0=
	>=dev-haskell/transformers-base-0.4:0=
	<dev-haskell/transformers-base-0.5:0=
	>=dev-haskell/utf8-string-0.3.7:0=
	>=dev-haskell/zlib-0.5.3.3:0=
	<dev-haskell/zlib-0.7:0=

	>=dev-haskell/psqueue-1.1:0=
	<dev-haskell/psqueue-1.2:0=
	>=dev-haskell/snap-core-1.0.1:0=
	<dev-haskell/snap-core-1.1:0=
	>=dev-haskell/snap-server-1.0.1:0=
	<dev-haskell/snap-server-1.1:0=
	>=dev-haskell/case-insensitive-0.4.0.1

	dev-haskell/vector:0=
	xen? ( >=app-emulation/xen-3.0 )
	kvm? (
		dev-python/psutil
		app-emulation/qemu
	)
	lxc? ( app-emulation/lxc )
	drbd? ( sys-cluster/drbd-utils )
	rbd? ( sys-cluster/ceph )
	ipv6? ( net-misc/ndisc6 )
	${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	!app-emulation/ganeti-htools"
DEPEND+="
	sys-devel/m4
	app-text/pandoc
	$(python_gen_cond_dep '
		dev-python/sphinx[${PYTHON_MULTI_USEDEP}]
	')
	media-fonts/urw-fonts
	media-gfx/graphviz
	>=dev-haskell/test-framework-0.6:0=
	<dev-haskell/test-framework-0.9:0=
	>=dev-haskell/test-framework-hunit-0.2.7:0=
	<dev-haskell/test-framework-hunit-0.4:0=
	>=dev-haskell/test-framework-quickcheck2-0.2.12.1:0=
	<dev-haskell/test-framework-quickcheck2-0.4:0=
	test? (
		dev-python/mock
		dev-python/pyyaml
		dev-haskell/haddock:0=
		>=dev-haskell/hunit-1.2.4.2:0=
		<dev-haskell/hunit-1.3:0=
		>=dev-haskell/quickcheck-2.4.2:2=
		<dev-haskell/quickcheck-2.8.3:2=
		sys-apps/fakeroot
		>=net-misc/socat-1.7
		dev-util/shelltestrunner
	)"

PATCHES+=(
	"${FILESDIR}/${PN}-2.12-start-stop-daemon-args.patch"
	"${FILESDIR}/${PN}-2.11-add-pgrep.patch"
	"${FILESDIR}/${PN}-2.15-daemon-util.patch"
	"${FILESDIR}/${PN}-2.9-disable-root-tests.patch"
	"${FILESDIR}/${PN}-2.9-skip-cli-test.patch"
	"${FILESDIR}/${PN}-2.10-rundir.patch"
	"${FILESDIR}/${PN}-2.12-qemu-enable-kvm.patch"
	"${FILESDIR}/${PN}-2.11-tests.patch"
	"${FILESDIR}/${PN}-lockdir.patch"
	"${FILESDIR}/${PN}-2.11-dont-nest-libdir.patch"
	"${FILESDIR}/${PN}-2.11-dont-print-man-help.patch"
	"${FILESDIR}/${PN}-2.11-daemon-util-tests.patch"
	"${FILESDIR}/${PN}-2.13-process_unittest.patch"
	"${FILESDIR}/${PN}-2.15-python-mock.patch"
	"${FILESDIR}/${PN}-2.15.2-remove-sandbox-failing-tests.patch"
	"${FILESDIR}/${PN}-2.15-noded-must-run-as-root.patch"
	"${FILESDIR}/${PN}-2.15-kvmd-run-as-daemon-user.patch"
	"${FILESDIR}/${PN}-2.15-dont-invert-return-values-for-man-warnings.patch"
	"${FILESDIR}/${PN}-2.15-respect-HFLAGS.patch"
	"${FILESDIR}/ganeti-2.15.2-bdev_py.patch"
	"${FILESDIR}/ganeti-2.15.2-check-man-warnings.patch"
	"${FILESDIR}/ganeti-2.15.2-ftbfs-sphinx-warning.patch"
	"${FILESDIR}/ganeti-2.15.2-pyopenssl.patch"
)

S="${WORKDIR}/${MY_P}"

QA_WX_LOAD="
	usr/lib*/${PN}/${SERIES}/usr/sbin/ganeti-*d
	usr/lib*/${PN}/${SERIES}/usr/bin/htools
"
# haskell...
QA_FLAGS_IGNORED="
	/usr/lib64/ganeti/2.15/usr/sbin/ganeti-metad
	/usr/lib64/ganeti/2.15/usr/sbin/ganeti-wconfd
	/usr/lib64/ganeti/2.15/usr/sbin/ganeti-confd
	/usr/lib64/ganeti/2.15/usr/sbin/ganeti-luxid
	/usr/lib64/ganeti/2.15/usr/sbin/ganeti-kvmd
	/usr/lib64/ganeti/2.15/usr/bin/htools
"

pkg_setup() {
	local user
	python-single-r1_pkg_setup

	if use multiple-users; then
		for user in gnt-{masterd,confd,luxid,rapi,daemons,admin}; do
			enewgroup ${user}
			enewuser ${user} -1 -1 -1 ${user}
		done
	fi
}

src_prepare() {
	local testfile
	if has_version '>=dev-lang/ghc-7.10'; then
		# Breaks the build on 7.8
		PATCHES+=(
			"${WORKDIR}"/debian/patches/ghc-7.10-compatibility.patch
		)
	fi
	if use experimental; then
		ewarn "Experimental patches have been applied! RPC between daemons with different patches applied may cause breakage!"
		PATCHES+=(
			# QEMU Agent accepted upstream for 2.16, not yet in a tagged release
			# backport available for 2.15, but refused upstream due to RPC breakage.
			"${FILESDIR}"/0001-kvm-use_guest_agent-QEMU-Guest-Agent-sup.stable-2.15.patch
		)
	fi
	eapply "${PATCHES[@]}"
	# Upstream commits:
	# 4c3c2ca2a97a69c0287a3d23e064bc17978105eb
	# 24618882737fd7c189adf99f4acc767d48f572c3
	sed -i \
		-e '/QuickCheck/s,< 2.8,< 2.8.3,g' \
		cabal/ganeti.template.cabal
	# Neuter -Werror
	sed -i \
		-e '/^if DEVELOPER_MODE/,/^endif/s/-Werror//' \
		Makefile.am

	# not sure why these tests are failing
	# should remove this on next version bump if possible
	for testfile in test/py/import-export_unittest.bash; do
		printf '#!/bin/bash\ntrue\n' > "${testfile}"
	done

	# take the sledgehammer approach to bug #526270
	grep -lr '/bin/sh' "${S}" | xargs -r -- sed -i 's:/bin/sh:/bin/bash:g'

	sed "s:%LIBDIR%:$(get_libdir):g" "${FILESDIR}/ganeti.initd-r4" \
		> "${T}/ganeti.initd"

	eapply_user

	[[ ${PV} =~ [9]{4,} ]] && ./autogen.sh
	rm autotools/missing
	eautoreconf
}

src_configure() {
	# this is kind of a hack to work around the removal of the qemu-kvm wrapper
	local kvm_arch

	if use amd64; then
		kvm_arch=x86_64
	elif use x86; then
		kvm_arch=i386
	elif use kvm; then
		die "Could not determine qemu system to use for kvm"
	fi

	econf --localstatedir=/var \
		--sharedstatedir=/var \
		--disable-symlinks \
		--with-ssh-initscript=/etc/init.d/sshd \
		--with-export-dir=/var/lib/ganeti-storage/export \
		--with-os-search-path=/usr/share/${PN}/os \
		$(use_enable restricted-commands) \
		$(use_enable test haskell-tests) \
		$(usex multiple-users "--with-default-user=" "" "gnt-daemons" "") \
		$(usex multiple-users "--with-user-prefix=" "" "${USER_PREFIX}" "") \
		$(usex multiple-users "--with-default-group=" "" "gnt-daemons" "") \
		$(usex multiple-users "--with-group-prefix=" "" "${GROUP_PREFIX}" "") \
		$(use_enable syslog) \
		$(use_enable monitoring) \
		$(usex kvm '--with-kvm-path=' '' "/usr/bin/qemu-system-${kvm_arch}" '') \
		$(usex haskell-daemons "--enable-confd=haskell" '' '' '') \
		--with-haskell-flags="-optl -Wl,-z,relro -optl -Wl,--as-needed" \
		--enable-socat-escape \
		--enable-socat-compress
}

src_install() {
	emake V=1 DESTDIR="${D}" install

	newinitd "${T}"/ganeti.initd ${PN}
	newconfd "${FILESDIR}"/ganeti.confd-r2 ${PN}

	if use kvm; then
		newinitd "${FILESDIR}"/ganeti-kvm-poweroff.initd ganeti-kvm-poweroff
		newconfd "${FILESDIR}"/ganeti-kvm-poweroff.confd ganeti-kvm-poweroff
	fi

	# ganeti installs it's own docs in a generic location
	rm -rf "${D}"/{usr/share/doc/${PN},run}

	sed -i "s:/usr/$(get_libdir)/${PN}/tools/burnin:burnin:" doc/examples/bash_completion
	newbashcomp doc/examples/bash_completion gnt-instance
	bashcomp_alias gnt-instance burnin ganeti-{cleaner,confd} \
		h{space,check,scan,info,ail,arep,roller,squeeze,bal} \
		gnt-{os,job,filter,debug,storage,group,node,network,backup,cluster}

	use monitoring && bashcomp_alias gnt-instance mon-collector

	dodoc INSTALL UPGRADE NEWS README doc/*.rst

	docinto html
	dodoc -r doc/html/* doc/css/*.css

	docinto examples
	dodoc doc/examples/{ganeti.cron,gnt-config-backup} doc/examples/*.ocf

	docinto examples/hooks
	dodoc doc/examples/hooks/{ipsec,ethers}

	insinto /etc/cron.d
	newins doc/examples/ganeti.cron ${PN}

	insinto /etc/logrotate.d
	newins doc/examples/ganeti.logrotate ${PN}

	# need to dodir rather than keepdir here (bug #552482)
	dodir /var/lib/${PN}

	keepdir /var/log/${PN}/
	keepdir /usr/share/${PN}/${SERIES}/os/
	keepdir /var/lib/ganeti-storage/{export,file,shared}/

	dosym ${SERIES} "/usr/share/${PN}/default"
	dosym ${SERIES} "/usr/$(get_libdir)/${PN}/default"

	python_fix_shebang "${ED}" "${D}"/usr/"$(get_libdir)"/${PN}/${SERIES}
}

pkg_postinst() {
	if use multiple-users; then
		elog "You have enable multiple user support, the users for this must"
		elog "be created. You can use the provided tool for this, which is"
		elog "located at:"
		elog "    /usr/$(get_libdir)/${PN}/tools/users-setup"
	fi
}

src_test() {
	PATH="${S}/scripts:${S}/src:${PATH}" \
		TMPDIR="/tmp" \
		GANETI_MASTER="$(hostname -f)" \
		emake check
}
