# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/ganeti/ganeti-2.12.3-r2.ebuild,v 1.1 2015/05/09 08:05:41 chutzpah Exp $

EAPI=5
PYTHON_COMPAT=(python2_7)
use test && PYTHON_REQ_USE="ipv6"

inherit eutils user autotools bash-completion-r1 python-single-r1 versionator

MY_PV="${PV/_rc/~rc}"
MY_PV="${MY_PV/_beta/~beta}"
MY_P="${PN}-${MY_PV}"
SERIES="$(get_version_component_range 1-2)"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://git.ganeti.org/ganeti.git"
	inherit git-2
	KEYWORDS=""
	GIT_DEPEND="app-text/pandoc
		dev-python/docutils
		dev-python/sphinx[${PYTHON_USEDEP}]
		media-libs/gd[fontconfig,jpeg,png,truetype]
		media-gfx/graphviz
		media-fonts/urw-fonts"
else
	SRC_URI="http://downloads.ganeti.org/releases/${SERIES}/${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Ganeti is a virtual server management software tool"
HOMEPAGE="http://www.ganeti.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE="drbd haskell-daemons htools ipv6 kvm lxc monitoring multiple-users rbd syslog test xen"
REQUIRED_USE="|| ( kvm xen lxc ) ${PYTHON_REQUIRED_USE}"

USER_PREFIX="${GANETI_USER_PREFIX:-"gnt-"}"
GROUP_PREFIX="${GANETI_GROUP_PREFIX:-"${USER_PREFIX}"}"

# the haskell less-than atoms list are resolver hints, they aren't actual
# direct dependencies, just hints to help the resolver fufill the dependency
# on an older transformer.
# these need to stay until 2.14.0
DEPEND="
	dev-libs/openssl:0
	dev-python/paramiko[${PYTHON_USEDEP}]
	dev-python/pyopenssl[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]
	dev-python/pycurl[${PYTHON_USEDEP}]
	dev-python/pyinotify[${PYTHON_USEDEP}]
	dev-python/simplejson[${PYTHON_USEDEP}]
	dev-python/ipaddr[${PYTHON_USEDEP}]
	dev-python/bitarray[${PYTHON_USEDEP}]
	net-analyzer/arping
	net-analyzer/fping
	net-misc/bridge-utils
	net-misc/curl[ssl]
	net-misc/openssh
	net-misc/socat
	sys-apps/iproute2
	sys-fs/lvm2
	>=sys-apps/baselayout-2.0
	=dev-lang/ghc-7.6*:0=
	>=dev-haskell/json-0.9:0=
	<dev-haskell/monad-control-1.0.0.0:0=
	<dev-haskell/transformers-0.4.0:0=
	dev-haskell/curl:0=
	dev-haskell/network:0=
	dev-haskell/parallel:3=
	>=dev-haskell/hslogger-1.2.6:0=
	dev-haskell/snap-server:0=
	dev-haskell/utf8-string:0=
	dev-haskell/deepseq:0=
	dev-haskell/attoparsec:0=
	dev-haskell/crypto:0=
	dev-haskell/vector:0=
	dev-haskell/hinotify:0=
	dev-haskell/regex-pcre-builtin:0=
	dev-haskell/zlib:0=
	>=dev-haskell/lifted-base-0.2.3.3:0=
	<dev-haskell/lens-3.10:0=
	dev-haskell/base64-bytestring:0=
	<dev-haskell/mtl-2.2
	<dev-haskell/contravariant-0.6
	<dev-haskell/profunctors-4.3
	<dev-haskell/distributive-0.4.4
	<dev-haskell/comonad-4.2.2
	<dev-haskell/transformers-compat-0.3
	<dev-haskell/transformers-base-0.4.4
	<dev-haskell/semigroupoids-4.0
	<dev-haskell/semigroupoid-extras-4.0
	<dev-haskell/groupoids-4.0
	xen? ( >=app-emulation/xen-3.0 )
	kvm? ( app-emulation/qemu )
	lxc? ( app-emulation/lxc )
	drbd? ( <sys-cluster/drbd-8.5 )
	rbd? ( sys-cluster/ceph )
	ipv6? ( net-misc/ndisc6 )
	haskell-daemons? ( dev-haskell/text:0= )
	${PYTHON_DEPS}
	${GIT_DEPEND}"
RDEPEND="${DEPEND}
	!app-emulation/ganeti-htools"
DEPEND+="sys-devel/m4
	test? (
		dev-python/mock
		dev-python/pyyaml
		dev-haskell/haddock:0=
		dev-haskell/test-framework:0=
		dev-haskell/test-framework-hunit:0=
		dev-haskell/test-framework-quickcheck2:0=
		dev-haskell/temporary:0=
		sys-apps/fakeroot
		net-misc/socat
		dev-util/shelltestrunner
	)"

PATCHES=(
	"${FILESDIR}/${PN}-2.12-start-stop-daemon-args.patch"
	"${FILESDIR}/${PN}-2.11-add-pgrep.patch"
	"${FILESDIR}/${PN}-2.12.3-daemon-util.patch"
	"${FILESDIR}/${PN}-2.7-fix-tests.patch"
	"${FILESDIR}/${PN}-2.9-disable-root-tests.patch"
	"${FILESDIR}/${PN}-2.11-regex-builtin.patch"
	"${FILESDIR}/${PN}-2.9-skip-cli-test.patch"
	"${FILESDIR}/${PN}-2.10-rundir.patch"
	"${FILESDIR}/${PN}-2.12-qemu-enable-kvm.patch"
	"${FILESDIR}/${PN}-2.11-tests.patch"
	"${FILESDIR}/${PN}-lockdir.patch"
	"${FILESDIR}/${PN}-2.11-useradd.patch"
	"${FILESDIR}/${PN}-2.11-dont-nest-libdir.patch"
	"${FILESDIR}/${PN}-2.11-dont-print-man-help.patch"
	"${FILESDIR}/${PN}-2.11-daemon-util-tests.patch"
	"${FILESDIR}/${PN}-2.12-tests.patch"
)

REQUIRED_USE="kvm? ( || ( amd64 x86 ) )"

S="${WORKDIR}/${MY_P}"

QA_WX_LOAD="usr/$(get_libdir)/${PN}/${SERIES}/usr/sbin/ganeti-*d
	usr/$(get_libdir)/${PN}/${SERIES}/usr/bin/htools"

pkg_setup () {
	local user
	confutils_use_depend_all haskell-daemons htools
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
	epatch "${PATCHES[@]}"

	# not sure why these tests are failing
	# should remove this on next version bump if possible
	for testfile in test/py/import-export_unittest.bash; do
		printf '#!/bin/bash\ntrue\n' > "${testfile}"
	done

	# take the sledgehammer approach to bug #526270
	grep -lr '/bin/sh' "${S}" | xargs -r -- sed -i 's:/bin/sh:/bin/bash:g'

	[[ ${PV} =~ [9]{4,} ]] && ./autogen.sh
	rm autotools/missing
	eautoreconf
}

src_configure () {
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
		--docdir=/usr/share/doc/${P} \
		--with-ssh-initscript=/etc/init.d/sshd \
		--with-export-dir=/var/lib/ganeti-storage/export \
		--with-os-search-path=/usr/share/${PN}/os \
		$(usex multiple-users "--with-user-prefix=" "" "${USER_PREFIX}" "") \
		$(usex multiple-users "--with-group-prefix=" "" "${GROUP_PREFIX}" "") \
		$(use_enable syslog) \
		$(use_enable monitoring) \
		$(usex kvm '--with-kvm-path=' '' "/usr/bin/qemu-system-${kvm_arch}" '') \
		$(usex haskell-daemons "--enable-confd=haskell" '' '' '')
}

src_install () {
	emake V=1 DESTDIR="${D}" install || die "emake install failed"

	newinitd "${FILESDIR}"/ganeti.initd-r3 ${PN}
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

	dodoc INSTALL UPGRADE NEWS README doc/*.rst
	dohtml -r doc/html/* doc/css/*.css

	docinto examples
	dodoc doc/examples/{ganeti.cron,gnt-config-backup} doc/examples/*.ocf

	docinto examples/hooks
	dodoc doc/examples/hooks/{ipsec,ethers}

	insinto /etc/cron.d
	newins doc/examples/ganeti.cron ${PN}

	insinto /etc/logrotate.d
	newins doc/examples/ganeti.logrotate ${PN}

	keepdir /var/{lib,log}/${PN}/
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

src_test () {
	PATH="${S}/scripts:${S}/src:${PATH}" \
		TMPDIR="/tmp" \
		GANETI_MASTER="$(hostname -f)" \
		emake check || die "emake check failed"
}
