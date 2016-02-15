# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=(python2_7)
use test && PYTHON_REQ_USE="ipv6"

inherit eutils confutils autotools bash-completion-r1 python-single-r1 versionator

MY_PV="${PV/_rc/~rc}"
#MY_PV="${PV/_beta/~beta}"
MY_P="${PN}-${MY_PV}"
SERIES="$(get_version_component_range 1-2)"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://git.ganeti.org/ganeti.git"
	inherit git-2
	KEYWORDS=""
	# you will need to pull in the haskell overlay for pandoc
	GIT_DEPEND="app-text/pandoc
		dev-python/docutils
		dev-python/sphinx
		media-libs/gd[fontconfig,jpeg,png,truetype]
		media-gfx/graphviz
		media-fonts/urw-fonts"
else
	SRC_URI="http://downloads.ganeti.org/releases/${SERIES}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Ganeti is a virtual server management software tool"
HOMEPAGE="https://code.google.com/p/ganeti/"

LICENSE="GPL-2"
SLOT="0"
IUSE="kvm xen lxc drbd htools syslog ipv6 haskell-daemons rbd test"
REQUIRED_USE="|| ( kvm xen lxc )"

HASKELL_DEPS=">=dev-lang/ghc-6.12:0=
	<dev-lang/ghc-7.8
	dev-haskell/json:0=
	dev-haskell/curl:0=
	dev-haskell/network:0=
	dev-haskell/parallel:3=
	dev-haskell/hslogger:0=
	dev-haskell/utf8-string:0=
	dev-haskell/attoparsec:0=
	dev-haskell/crypto:0="

DEPEND="xen? ( >=app-emulation/xen-3.0 )
	kvm? ( app-emulation/qemu )
	lxc? ( app-emulation/lxc )
	drbd? ( <sys-cluster/drbd-8.5 )
	rbd? ( sys-cluster/ceph )
	ipv6? ( net-misc/ndisc6 )
	haskell-daemons? (
		${HASKELL_DEPS}
		dev-haskell/text:0=
		dev-haskell/hinotify:0=
		dev-haskell/regex-pcre-builtin:0=
		dev-haskell/vector:0=
	)
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
	${PYTHON_DEPS}
	${GIT_DEPEND}"
RDEPEND="${DEPEND}
	!app-emulation/ganeti-htools"
DEPEND+="${HASKELL_DEPS}
	sys-devel/m4
	test? (
		dev-python/mock
		dev-python/pyyaml
		dev-haskell/test-framework:0=
		dev-haskell/test-framework-hunit:0=
		dev-haskell/test-framework-quickcheck2:0=
		dev-haskell/temporary:0=
		sys-apps/fakeroot
	)"

PATCHES=(
	"${FILESDIR}/${PN}-2.6-fix-args.patch"
	"${FILESDIR}/${PN}-2.6-add-pgrep.patch"
	"${FILESDIR}/${PN}-2.7-fix-tests.patch"
	"${FILESDIR}/${PN}-2.9-disable-root-tests.patch"
	"${FILESDIR}/${PN}-2.9-regex-builtin.patch"
	"${FILESDIR}/${PN}-2.9-skip-cli-test.patch"
	"${FILESDIR}/${PN}-2.10-rundir.patch"
	"${FILESDIR}/${PN}-lockdir.patch"
)

S="${WORKDIR}/${MY_P}"

pkg_setup () {
	confutils_use_depend_all haskell-daemons htools
	python-single-r1_pkg_setup
}

src_prepare() {
	epatch "${PATCHES[@]}"
	[[ ${PV} == "9999" ]] && ./autogen.sh
	rm autotools/missing
	eautoreconf
}

src_configure () {
	econf --localstatedir=/var \
		--sharedstatedir=/var \
		--disable-symlinks \
		--docdir=/usr/share/doc/${P} \
		--with-ssh-initscript=/etc/init.d/sshd \
		--with-export-dir=/var/lib/ganeti-storage/export \
		--with-os-search-path=/usr/share/${PN}/os \
		$(use_enable syslog) \
		$(usex kvm '--with-kvm-path=' '' '/usr/bin/qemu-kvm' '') \
		$(usex haskell-daemons "--enable-confd=haskell" '' '' '')
}

src_install () {
	emake V=1 DESTDIR="${D}" install || die "emake install failed"

	newinitd "${FILESDIR}"/ganeti.initd-r3 ${PN}
	newconfd "${FILESDIR}"/ganeti.confd-r2 ${PN}

	use kvm && newinitd "${FILESDIR}"/ganeti-kvm-poweroff.initd ganeti-kvm-poweroff
	use kvm && newconfd "${FILESDIR}"/ganeti-kvm-poweroff.confd ganeti-kvm-poweroff
	newbashcomp doc/examples/bash_completion ganeti
	dodoc INSTALL UPGRADE NEWS README doc/*.rst
	dohtml -r doc/html/*
	rm -rf "${D}"/{usr/share/doc/${PN},run}

	docinto examples
	dodoc doc/examples/{ganeti.cron,gnt-config-backup} doc/examples/*.ocf

	docinto examples/hooks
	dodoc doc/examples/hooks/{ipsec,ethers}

	insinto /etc/cron.d
	newins doc/examples/ganeti.cron ${PN}

	insinto /etc/logrotate.d
	newins doc/examples/ganeti.logrotate ${PN}

	python_fix_shebang "${D}"/usr/"$(get_libdir)"/${PN}/${SERIES}

	keepdir /var/{lib,log}/${PN}/
	keepdir /usr/share/${PN}/${SERIES}/os/
	keepdir /var/lib/ganeti-storage/{export,file,shared}/

	dosym ${SERIES} "/usr/share/${PN}/default"
	dosym ${SERIES} "/usr/$(get_libdir)/${PN}/default"

	python_fix_shebang "${ED}"
}

src_test () {
	emake check || die "emake check failed"
}
