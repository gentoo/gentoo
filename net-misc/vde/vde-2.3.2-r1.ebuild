# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/vde/vde-2.3.2-r1.ebuild,v 1.1 2014/08/20 11:34:55 pinkbyte Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit eutils python-single-r1 user

MY_P="${PN}2-${PV}"

DESCRIPTION="Virtual distributed ethernet emulator for emulators like qemu, bochs, and uml"
SRC_URI="mirror://sourceforge/vde/${MY_P}.tar.bz2"
HOMEPAGE="http://vde.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

IUSE="pcap python ssl static-libs"

RDEPEND="pcap? ( net-libs/libpcap )
	python? ( ${PYTHON_DEPS} )
	ssl? ( dev-libs/openssl )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	# default group already used in kqemu
	enewgroup qemu

	python-single-r1_pkg_setup
}

src_prepare() {
	epatch_user
}

src_configure() {
	econf \
		$(use_enable pcap) \
		$(use_enable python) \
		$(use_enable ssl cryptcab) \
		$(use_enable static-libs static)
}

src_compile() {
	emake -j1
}

src_install() {
	default
	prune_libtool_files

	newinitd "${FILESDIR}"/vde.init vde
	newconfd "${FILESDIR}"/vde.conf vde
}

pkg_postinst() {
	einfo "To start vde automatically add it to the default runlevel:"
	einfo "# rc-update add vde default"
	einfo "You need to setup tap0 in /etc/conf.d/net"
	einfo "To use it as an user be sure to set a group in /etc/conf.d/vde"
	einfo "Users of the group can then run: $ vdeq qemu -sock /var/run/vde.ctl ..other opts"
}
