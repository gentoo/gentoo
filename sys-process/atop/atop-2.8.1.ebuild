# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Check on bumps of atop
# https://www.atoptool.nl/downloadnetatop.php
NETATOP_VER=3.1

# Controls 'netatop' kernel module
MODULES_OPTIONAL_USE="modules"
NETATOP_P=net${PN}-${NETATOP_VER}
NETATOP_S="${WORKDIR}"/${NETATOP_P}

inherit linux-info linux-mod systemd toolchain-funcs

DESCRIPTION="Resource-specific view of processes"
HOMEPAGE="https://www.atoptool.nl/ https://github.com/Atoptool/atop"
SRC_URI="https://github.com/Atoptool/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" modules? ( https://www.atoptool.nl/download/${NETATOP_P}.tar.gz )"

# Module is GPL-2 as well
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~mips ppc ~ppc64 ~riscv x86 ~amd64-linux ~x86-linux"

RDEPEND="
	sys-libs/ncurses:=
	>=sys-process/acct-6.6.4-r1
	modules? ( sys-libs/zlib )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-2.6.0-build.patch
)

pkg_pretend() {
	if use kernel_linux ; then
		CONFIG_CHECK="~BSD_PROCESS_ACCT"
		check_extra_config
	fi
}

src_prepare() {
	default

	if use modules ; then
		cd "${WORKDIR}"/${NETATOP_P} || die
		eapply -p1 "${FILESDIR}"/${PN}-2.7.0-netatop-makefile.patch
		cd "${S}" || die
	fi

	tc-export CC PKG_CONFIG

	# bug #191926
	sed -i 's: root : :' atop.cronsysv || die

	# prefixify
	sed -i "s:/\(usr\|etc\|var\):${EPREFIX}/\1:g" Makefile || die
}

src_configure() {
	default

	BUILD_TARGETS="netatop.ko"
	MODULE_NAMES="netatop(:${NETATOP_S}/module)"
}

src_compile() {
	default

	linux-mod_src_compile
}

src_install() {
	linux-mod_src_install

	if use modules ; then
		# netatop's Makefile tries to build the kernel module for us
		# so let's just replicate parts of it here.
		emake -C "${NETATOP_S}"/daemon all

		dosbin "${NETATOP_S}"/daemon/netatopd
		doman "${NETATOP_S}"/man/*

		systemd_dounit "${NETATOP_S}"/netatop.service

		# TODO: Release after 2.8.0 may contain this, check!
		newinitd "${FILESDIR}"/netatop.rc netatop
	fi

	emake DESTDIR="${D}" genericinstall

	# useless -${PV} copies ?
	rm "${ED}"/usr/bin/atop*-${PV} || die

	newinitd atop.rc.openrc ${PN}
	newinitd atopacct.rc.openrc atopacct

	systemd_dounit "${S}"/${PN}.service
	systemd_dounit "${S}"/atopacct.service

	dodoc atop.cronsysv AUTHORS README

	exeinto /usr/share/${PN}
	doexe ${PN}.daily

	insinto /etc/default
	newins ${PN}{.default,}

	keepdir /var/log/${PN}
}
