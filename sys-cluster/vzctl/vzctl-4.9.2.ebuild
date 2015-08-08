# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit base bash-completion-r1 eutils toolchain-funcs udev

DESCRIPTION="OpenVZ ConTainers control utility"
HOMEPAGE="http://openvz.org/"
SRC_URI="http://download.openvz.org/utils/${PN}/${PV}/src/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86 -amd64-fbsd -sparc-fbsd -x86-fbsd"
IUSE="+ploop +vzmigrate"

RDEPEND="net-firewall/iptables
		sys-apps/ed
		>=sys-apps/iproute2-3.3.0
		>=sys-fs/vzquota-3.1
		ploop? (
			>=sys-cluster/ploop-1.13
			sys-block/parted
			sys-fs/quota
			dev-libs/libxml2
			)
		>=dev-libs/libcgroup-0.38
		vzmigrate? (
		net-misc/openssh
		net-misc/rsync[xattr,acl]
		app-arch/tar[xattr,acl]
		net-misc/bridge-utils
		virtual/awk
			)
		virtual/udev
		sys-apps/attr
		"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	"

src_prepare() {

	# Set default OSTEMPLATE on gentoo
	sed -i -e 's:=redhat-:=gentoo-:' etc/dists/default || die 'sed on etc/dists/default failed'
	# Set proper udev directory
	sed -i -e "s:/lib/udev:$(get_udevdir):" src/lib/dev.c || die 'sed on src/lib/dev.c failed'
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
	rm -rf "${ED}"/etc/bash_completion.d
	newbashcomp etc/bash_completion.d/vzctl.sh ${PN}

	# We need to keep some dirs
	keepdir /vz/{dump,lock,root,private,template/cache}
	keepdir /etc/vz/names /var/lib/vzctl/veip
}

pkg_postinst() {
	einfo "This vzctl release required kernel above 2.6.32.92"

	einfo "If you have checkpoint suspend/restore feature in vanilla kernel"
	einfo "please install "sys-process/criu" "
	einfo "This is experimental and not stable ( in gentoo ) now"

	einfo "if you have work with  .xz compressed template, please install app-arch/xz-utils"
	einfo "if you have check signature donwloaded template - install gpg "
}
