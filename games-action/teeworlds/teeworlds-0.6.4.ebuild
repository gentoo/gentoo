# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
inherit eutils multiprocessing python-any-r1 toolchain-funcs versionator

REVISION="b177-rff25472"

DESCRIPTION="Online multi-player platform 2D shooter"
HOMEPAGE="http://www.teeworlds.com/"
SRC_URI="https://downloads.teeworlds.com/${P}-src.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="debug dedicated"

RDEPEND="
	!dedicated? (
		app-arch/bzip2
		media-libs/freetype
		media-libs/libsdl[X,sound,opengl,video]
		media-libs/pnglite
		media-sound/wavpack
		virtual/glu
		virtual/opengl
		x11-libs/libX11 )
	sys-libs/zlib"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	~dev-util/bam-0.4.0"

S=${WORKDIR}/${P}-src
MY_PV=$(get_version_component_range 1-2)

PATCHES=(
	"${FILESDIR}/${MY_PV}/01-use-system-wavpack.patch"
	"${FILESDIR}/${MY_PV}/02-fixed-wavpack-sound-loading.patch"
	"${FILESDIR}/${MY_PV}/03-use-system-pnglite.patch"
	"${FILESDIR}/${MY_PV}/04-dedicated.patch"
	"${FILESDIR}/${MY_PV}/05-cc-cflags.patch"
)

pkg_setup() {
	python-any-r1_pkg_setup
}

src_prepare() {
	default

	rm -r src/engine/external/* || die

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
		newbin ${PN}_srv_d ${PN}_srv
	else
		dobin ${PN}_srv
	fi
	if ! use dedicated; then
		if use debug; then
			newbin ${PN}_d ${PN}
		else
			dobin ${PN}
		fi

		doicon "${FILESDIR}"/${PN}.xpm
		make_desktop_entry ${PN} Teeworlds

		insinto /usr/share/${PN}/data
		doins -r data/*
	else
		insinto /usr/share/${PN}/data/maps
		doins -r data/maps/*
	fi
	newinitd "${FILESDIR}"/${PN}-init.d ${PN}
	insinto "/etc/${PN}"
	doins "${FILESDIR}"/teeworlds_srv.cfg

	dodoc readme.txt
}
