# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 toolchain-funcs optfeature udev

DESCRIPTION="OpenVZ ConTainers control utility"
HOMEPAGE="http://openvz.org/"
SRC_URI="http://download.openvz.org/utils/${PN}/${PV}/src/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"
IUSE="+ploop +vzmigrate"

BDEPEND="virtual/pkgconfig"
RDEPEND="
	>=dev-libs/libcgroup-0.38
	net-firewall/iptables
	sys-apps/attr
	sys-apps/ed
	>=sys-apps/iproute2-3.3.0
	>=sys-fs/vzquota-3.1
	virtual/udev
	ploop? (
		dev-libs/libxml2
		sys-block/parted
		>=sys-cluster/ploop-1.13
		sys-fs/quota
	)
	vzmigrate? (
		app-arch/tar[xattr,acl]
		net-misc/openssh
		net-misc/rsync[xattr,acl]
		net-misc/bridge-utils
		virtual/awk
	)
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-glibc225.patch
	"${FILESDIR}"/${P}-glibc225-2.patch
)

src_prepare() {
	# Set default OSTEMPLATE on gentoo
	sed -i -e 's:=redhat-:=gentoo-:' etc/dists/default || die 'sed on etc/dists/default failed'
	# Set proper udev directory
	sed -i -e "s:/lib/udev:$(get_udevdir):" src/lib/dev.c || die 'sed on src/lib/dev.c failed'

	default
}

src_configure() {
	econf \
		--localstatedir=/var \
		--enable-udev \
		--enable-bashcomp \
		--enable-logrotate \
		--with-vz \
		$(use_with ploop) \
		--with-cgroup
}

src_install() {
	emake DESTDIR="${D}" udevdir="$(get_udevdir)"/rules.d install install-gentoo

	# install the bash-completion script into the right location
	rm -rf "${ED}"/etc/bash_completion.d || die
	newbashcomp etc/bash_completion.d/vzctl.sh ${PN}

	# We need to keep some dirs
	keepdir /vz/{dump,lock,root,private,template/cache}
	keepdir /etc/vz/names /var/lib/vzctl/veip
}

pkg_postinst() {
	einfo "This vzctl release requires a kernel above 2.6.32.92"

	optfeature "Checkpoint suspend/restore support (experimental)" sys-process/criu
	optfeature "Compressed .xz templates" app-arch/xz-utils
	optfeature "Signed templates" app-crypt/gnupg
}
