# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit linux-info flag-o-matic eutils

MY_PV=${PV/_/.}
MY_P=${PN}-${MY_PV}

DESCRIPTION="Device-mapper RAID tool and library"
HOMEPAGE="https://people.redhat.com/~heinzm/sw/dmraid/"
SRC_URI="https://people.redhat.com/~heinzm/sw/dmraid/src/old/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static selinux"

DEPEND=">=sys-fs/lvm2-2.02.45
	selinux? ( sys-libs/libselinux
		   sys-libs/libsepol )"
S=${WORKDIR}/${PN}/${MY_PV}

pkg_setup() {
	if kernel_is lt 2 6 ; then
		ewarn "You are using a kernel < 2.6"
		ewarn "DMraid uses recently introduced Device-Mapper features."
		ewarn "These might be unavailable in the kernel you are running now."
	fi
	if use static && use selinux ; then
		eerror "ERROR - cannot compile static with libselinux / libsepol"
		die "USE flag conflicts."
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/dmraid-destdir-fix.patch
}

src_compile() {
	econf \
		$(use_enable static static_link) \
		$(use_enable selinux libselinux) \
		$(use_enable selinux libsepol) \
		|| die "econf failed"
	emake -j1 || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc CHANGELOG README TODO KNOWN_BUGS doc/*
}

pkg_postinst() {
	einfo "For booting Gentoo from Device-Mapper RAID you can use Genkernel."
	einfo " "
	einfo "Genkernel will generate the kernel and the initrd with a statically "
	einfo "linked dmraid binary (its own version which may not be the same as this version):"
	einfo "emerge -av sys-kernel/genkernel"
	einfo "genkernel --dmraid --udev all"
	einfo " "
	einfo "If you would rather use this version of DMRAID with Genkernel, copy the distfile"
	einfo "from your distdir to '/usr/share/genkernel/pkg/' and update the following"
	einfo "in /etc/genkernel.conf:"
	einfo "DMRAID_VER=\"${MY_PV/_/.}\""
	einfo "DMRAID_SRCTAR=\"\${GK_SHARE}/pkg/${A}\""
	einfo " "
	ewarn "DMRAID should be safe to use, but no warranties can be given"
	einfo " "
}
