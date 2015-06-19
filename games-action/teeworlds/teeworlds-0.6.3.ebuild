# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/teeworlds/teeworlds-0.6.3.ebuild,v 1.3 2015/03/25 13:46:37 ago Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit eutils multiprocessing python-any-r1 toolchain-funcs games

REVISION="b177-r50edfd37"

DESCRIPTION="Online multi-player platform 2D shooter"
HOMEPAGE="http://www.teeworlds.com/"
SRC_URI="https://downloads.teeworlds.com/${P}-src.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug dedicated"

RDEPEND="
	!dedicated? ( media-libs/pnglite
		media-libs/libsdl[X,sound,opengl,video]
		media-sound/wavpack
		virtual/opengl
		app-arch/bzip2
		media-libs/freetype
		virtual/glu
		x11-libs/libX11 )
	sys-libs/zlib"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	~dev-util/bam-0.4.0"

S=${WORKDIR}/${P}-src

pkg_setup() {
	python-any-r1_pkg_setup
	games_pkg_setup
}

src_prepare() {
	rm -r src/engine/external/* || die

	# 01 & 02 from pull request: https://github.com/oy/teeworlds/pull/493
	EPATCH_SOURCE="${FILESDIR}/${PV}" EPATCH_SUFFIX="patch" EPATCH_FORCE="yes" \
		epatch

	cat <<- __EOF__ > "${S}/gentoo.lua"
		function addSettings(settings)
			print("Adding Gentoo settings")
			settings.optimize = 0
			settings.cc.exe_c = "$(tc-getCC)"
			settings.cc.exe_cxx = "$(tc-getCXX)"
			settings.cc.flags_c:Add("${CFLAGS}")
			settings.cc.flags_cxx:Add("${CXXFLAGS}")
			settings.link.exe = "$(tc-getCXX)"
			settings.link.flags:Add("${LDFLAGS}")
		end
	__EOF__

	sed -i \
		-e "s#/usr/share/games/teeworlds/data#${GAMES_DATADIR}/${PN}/data#" \
		src/engine/shared/storage.cpp || die
}

src_configure() {
	bam -v config || die
}

src_compile() {
	local myopt

	if use debug; then
		myopt=" server_debug"
	else
		myopt=" server_release"
	fi
	if ! use dedicated; then
		if use debug; then
			myopt+=" client_debug"
		else
			myopt+=" client_release"
		fi
	fi

	bam -v -a -j $(makeopts_jobs) ${myopt} || die
}

src_install() {
	if use debug; then
		newgamesbin ${PN}_srv_d ${PN}_srv
	else
		dogamesbin ${PN}_srv
	fi
	if ! use dedicated; then
		if use debug; then
			newgamesbin ${PN}_d ${PN}
		else
			dogamesbin ${PN}
		fi

		doicon "${FILESDIR}"/${PN}.xpm
		make_desktop_entry ${PN} Teeworlds

		insinto "${GAMES_DATADIR}"/${PN}/data
		doins -r data/*
	else
		insinto "${GAMES_DATADIR}"/${PN}/data/maps
		doins -r data/maps/*
	fi
	newinitd "${FILESDIR}"/${PN}-init.d ${PN}
	insinto "/etc/${PN}"
	doins "${FILESDIR}"/teeworlds_srv.cfg

	dodoc readme.txt

	prepgamesdirs
}
