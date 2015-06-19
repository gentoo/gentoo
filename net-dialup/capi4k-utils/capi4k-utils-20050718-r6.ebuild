# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/capi4k-utils/capi4k-utils-20050718-r6.ebuild,v 1.5 2014/06/22 20:50:59 zlogene Exp $

EAPI=5

inherit eutils linux-info multilib versionator

YEAR_PV="${PV:0:4}"
MON_PV="${PV:4:2}"
DAY_PV="${PV:6:2}"
MY_P="${PN}-${YEAR_PV}-${MON_PV}-${DAY_PV}"

PATCHVER="5"
TARBALL_FILES="capi4k-files-${PV}-r${PATCHVER}.tar.xz"
TARBALL_PATCHES="capi4k-patches-${PV}-r${PATCHVER}.tar.xz"

DESCRIPTION="CAPI4Linux Utils"
HOMEPAGE="ftp://ftp.in-berlin.de/pub/capi4linux/"
SRC_URI="ftp://ftp.in-berlin.de/pub/capi4linux/${MY_P}.tar.gz
	ftp://ftp.in-berlin.de/pub/capi4linux/OLD/${MY_P}.tar.gz
	http://sbriesen.de/gentoo/distfiles/${TARBALL_FILES}
	http://sbriesen.de/gentoo/distfiles/${TARBALL_PATCHES}"

LICENSE="GPL-2"
SLOT="0/3.0.4"
KEYWORDS="~alpha amd64 ppc x86"
IUSE="fax +pppd rcapid"

COMMON_DEP="pppd? ( net-dialup/ppp:= )"

DEPEND="${COMMON_DEP}
	virtual/linux-sources
	virtual/os-headers
	app-arch/xz-utils
	>=sys-apps/sed-4"

RDEPEND="${COMMON_DEP}
	dev-lang/perl"

S="${WORKDIR}/${PN}"

pkg_setup() {
	# check kernel config
	CONFIG_CHECK="~ISDN ~ISDN_CAPI ~ISDN_CAPI_CAPI20"
	use pppd && CONFIG_CHECK="${CONFIG_CHECK} ~ISDN_CAPI_MIDDLEWARE ~ISDN_CAPI_CAPIFS_BOOL"
	get_version  # config checked later in pkg_postinst

	# find installed pppd version
	if use pppd; then
		local INSTALLED_PPP="$(best_version net-dialup/ppp)"
		PPPVERSION="${INSTALLED_PPP#net-dialup/ppp-}"
		PPPVERSION="$(version_format_string '$1.$2.$3' ${PPPVERSION})"
		if [ -z "${PPPVERSION}" ]; then
			die "No pppd installation found"
		fi
	fi
}

src_prepare() {
	# add ppp-2.4.4 support
	epatch "${WORKDIR}/capi4k-patches/pppd244.diff"

	# add ppp-2.4.5 support
	epatch "${WORKDIR}/capi4k-patches/pppd245.diff"

	# apply rcapid patches
	epatch "${WORKDIR}/capi4k-patches/rcapid.diff"

	# apply msg2str-safety patch (see bug #170870)
	epatch "${WORKDIR}/capi4k-patches/msg2str-safety.diff"

	# apply capi20.h patches (needed for glibc-2.7)
	epatch "${WORKDIR}/capi4k-patches/capi20-include.diff"

	# set our config
	cp -f "${WORKDIR}/capi4k-files/config" .config
	# patch all Makefile.* and Rules.make to use our CFLAGS
	sed -i -e "s:^\(CFLAGS.*\)-O2:\1${CFLAGS}:g" */Makefile.* */Rules.make || die "sed failed"
	# patch capi20/Makefile.* to use -fPIC for shared library
	sed -i -e "s:^\(CFLAGS.*\):\1 -fPIC:g" capi20/Makefile.* || die "sed failed"
	# patch pppdcapiplugin/Makefile to use only the ppp versions we want
	sed -i -e "s:^\(PPPVERSIONS = \).*$:\1${PPPVERSION}:g" pppdcapiplugin/Makefile || die "sed failed"
	# patch capiinit/capiinit.c to look also in /lib/firmware
	sed -i -e "s:\(\"/lib/firmware/isdn\",\):\1 \"/lib/firmware\",:g" capiinit/capiinit.c || die "sed failed"
	# no, we don't need any devices nodes
	sed -i -e "s:\(sh scripts/makedev.sh\):echo \1:g" Makefile || die "sed failed"
	# add --libdir to configure call in Makefile
	sed -i -e "s:\(\./configure \):\1--libdir=/usr/$(get_libdir) :g" Makefile || die "sed failed"
	# patch /usr/lib/pppd in pppdcapiplugin tree
	sed -i -e "s:/usr/lib/pppd:/usr/$(get_libdir)/pppd:g" \
		pppdcapiplugin/ppp-*/Makefile pppdcapiplugin/{README,*.8} || die "sed failed"
	# respecting LDFLAGS (see bug #293209)
	sed -i -e "s:^LDFLAGS\s\(\s*\)=:LDFLAGS+\1=:g" \
		{capiinfo,capiinit,capifax,rcapid,avmb1}/Makefile* pppdcapiplugin/Rules.make || die
	# build rcapid
	if ! use rcapid; then
		sed -i -e "s:^\(CONFIG_RCAPID=.*\)$:# \1:g" .config || die
	fi
	# build pppdcapiplugin
	if use pppd; then
		# workaround for bug #511800
		if has_version \>=net-dialup/ppp-2.4.6; then
			pushd pppdcapiplugin &>/dev/null || die
			mv ppp-2.4.5 "ppp-${PPPVERSION}" || die
			popd &>/dev/null
		fi
	else
		sed -i -e "s:^\(CONFIG_PPPDCAPIPLUGIN=.*\)$:# \1:g" .config || die
	fi
	# build capifax
	if ! use fax; then
		sed -i -e "s:^\(CONFIG_CAPIFAX=.*\)$:# \1:g" .config || die
	fi

	epatch_user
}

src_configure() {
	# bug 468662 - we NEED to redefine AR and CC both with tc-export and at compile phase
	tc-export AR CC
	emake subconfig
}

src_compile() {
	# bug 468662 - we NEED to redefine AR and CC both with tc-export and at compile phase
	emake AR="$(tc-getAR)" CC="$(tc-getCC)"
}

src_install() {
	default_src_install
	prune_libtool_files

	# install base
	dobin scripts/isdncause
	newinitd "${WORKDIR}/capi4k-files/capi.initd" capi
	newconfd "${WORKDIR}/capi4k-files/capi.confd" capi
	insinto /etc
	doins "${WORKDIR}/capi4k-files/capi.conf"
	dodoc "${WORKDIR}/capi4k-files/README.gentoo" scripts/makedev.sh

	# install rcapid stuff
	if use rcapid; then
		insinto /etc/xinetd.d
		newins "${WORKDIR}/capi4k-files/rcapid.xinetd" rcapid
		newdoc rcapid/README README.rcapid
	fi

	# install pppdcapiplugin stuff
	if use pppd; then
		insinto /etc/ppp/peers
		doins pppdcapiplugin/peers/t-dsl
		docinto pppdcapiplugin
		dodoc pppdcapiplugin/README pppdcapiplugin/examples/*
		# fixing permissions (see bug #136120)
		fperms 0644 /usr/share/man/man8/capiplugin.8
	fi
}

pkg_postinst() {
	elog
	elog "Please read the instructions in README.gentoo in:"
	elog "/usr/share/doc/${PF}/"
	elog
	elog "Annotation for active AVM ISDN boards (B1 ISA/PCI, ...):"
	elog "If you run"
	elog "  emerge isdn-firmware"
	elog "you will probably find your board's firmware in /lib/firmware."
	elog
	elog "If you have another active ISDN board, you should create"
	elog "/lib/firmware and copy there your board's firmware."
	elog
	ewarn "If you're upgrading from an older capi4k-utils, you must recompile"
	ewarn "the other packages on your system that link with libcapi after the"
	ewarn "upgrade completes. To perform this action, please run revdep-rebuild"
	ewarn "in package app-portage/gentoolkit."
	elog
	elog "If any of the following kernel configuration options is missing, you"
	elog "should reconfigure and rebuild your kernel before using capi4k-utils."
	linux-info_pkg_setup
	elog
}
