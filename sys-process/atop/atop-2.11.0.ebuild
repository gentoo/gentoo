# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Check on bumps of atop
# https://www.atoptool.nl/downloadnetatop.php
NETATOP_VER=3.2.2

# Controls 'netatop' kernel module
MODULES_OPTIONAL_IUSE="modules"
NETATOP_P=netatop-${NETATOP_VER}
NETATOP_S="${WORKDIR}"/${NETATOP_P}

inherit linux-mod-r1 systemd toolchain-funcs

DESCRIPTION="Resource-specific view of processes"
HOMEPAGE="https://www.atoptool.nl/ https://github.com/Atoptool/atop"
SRC_URI="https://github.com/Atoptool/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" modules? ( https://www.atoptool.nl/download/${NETATOP_P}.tar.gz )"

# Module is GPL-2 as well
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-libs/glib
	sys-libs/ncurses:=
	sys-libs/zlib
	>=sys-process/acct-6.6.4-r1
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-2.11.0-build.patch
	"${FILESDIR}"/${PN}-2.11.0-respect-opt.patch
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

		sed \
			-e "s#\`uname -r\`#${KV_FULL}#g" \
			-e "s#\$(shell uname -r)#${KV_FULL}#g" \
			-i Makefile || die

		grep -rq "uname -r" && die "found uname calls"

		cd "${S}" || die
	fi

	tc-export CC PKG_CONFIG

	# bug #191926
	sed -i 's: root : :' atop.cronsysv || die

	# Prefixify
	sed -i "s:/\(usr\|etc\|var\):${EPREFIX}/\1:g" Makefile || die
}

src_compile() {
	default

	local modlist=( "netatop=:../${NETATOP_P}::netatop.ko" )
	linux-mod-r1_src_compile

	if use modules ; then
		# Don't let the Makefile try to build the module for us
		emake -C "${NETATOP_S}" netatopd
	fi
}

src_install() {
	linux-mod-r1_src_install

	if use modules ; then
		dosbin "${NETATOP_S}"/netatopd
		doman "${NETATOP_S}"/man/*

		systemd_dounit "${NETATOP_S}"/netatop.service

		newinitd "${NETATOP_S}"/netatop.rc netatop
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
