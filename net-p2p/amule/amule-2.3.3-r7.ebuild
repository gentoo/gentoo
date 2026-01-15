# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
WX_GTK_VER="3.2-gtk3"

inherit autotools eapi9-ver flag-o-matic wxwidgets xdg-utils

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/amule-project/amule"
	inherit git-r3
else
	MY_P="${PN/m/M}-${PV}"
	SRC_URI="https://download.sourceforge.net/${PN}/${MY_P}.tar.xz"
	S="${WORKDIR}/${MY_P}"
	KEYWORDS="~alpha amd64 ~arm ~mips ppc ppc64 ~riscv ~sparc x86"
fi

DESCRIPTION="aMule, the all-platform eMule p2p client"
HOMEPAGE="https://www.amule.org/"

LICENSE="GPL-2+"
SLOT="0"
IUSE="daemon debug geoip +gui nls remote stats upnp"

RDEPEND="
	dev-libs/boost:=
	dev-libs/crypto++:=
	sys-libs/binutils-libs:0=
	sys-libs/readline:0=
	virtual/zlib:=
	x11-libs/wxGTK:${WX_GTK_VER}=
	daemon? ( acct-user/amule )
	geoip? ( dev-libs/geoip )
	gui? ( x11-libs/wxGTK:${WX_GTK_VER}=[X] )
	nls? ( virtual/libintl )
	remote? (
		acct-user/amule
		media-libs/libpng:0=
	)
	stats? ( media-libs/gd:=[jpeg,png] )
	upnp? ( net-libs/libupnp:0 )
"
DEPEND="${RDEPEND}
	gui? ( dev-util/desktop-file-utils )
"
BDEPEND="
	virtual/pkgconfig
	>=dev-build/boost-m4-0.4_p20221019
	nls? ( sys-devel/gettext )
"

PATCHES=(
	"${FILESDIR}/${PN}-2.3.2-disable-version-check.patch"
	"${FILESDIR}/${PN}-2.3.3-fix-exception.patch"
	"${FILESDIR}/${P}-autoconf-2.70.patch"
	"${FILESDIR}/${PN}-2.3.3-backport-pr368.patch"
	"${FILESDIR}/${PN}-2.3.3-wx3.2.patch"
	"${FILESDIR}/${PN}-2.3.3-use-xdg-open-as-preview-default.patch"
	"${FILESDIR}/${P}-boost-1.87.patch"
	"${FILESDIR}/${P}-boost-1.89.patch" # bug 963550
)

src_prepare() {
	default
	rm m4/boost.m4 || die

	if [[ ${PV} == 9999 ]]; then
		./autogen.sh || die
	else
		eautoreconf
	fi
}

src_configure() {
	setup-wxwidgets

	use debug || append-cppflags -DwxDEBUG_LEVEL=0
	append-cxxflags -std=gnu++14

	local myconf=(
		--with-denoise-level=0
		--with-wx-config="${WX_CONFIG}"
		--enable-amulecmd
		--with-boost
		$(use_enable debug)
		$(use_enable daemon amule-daemon)
		$(use_enable geoip)
		$(use_enable nls)
		$(use_enable remote webserver)
		$(use_enable stats cas)
		$(use_enable stats alcc)
		$(use_enable upnp)
	)

	if use gui; then
		myconf+=(
			$(use_enable remote amule-gui)
			$(use_enable stats alc)
			$(use_enable stats wxcas)
		)
	else
		myconf+=(
			--disable-monolithic
			--disable-amule-gui
			--disable-alc
			--disable-wxcas
		)
	fi

	econf "${myconf[@]}"
}

src_test() {
	emake check
}

src_install() {
	default

	if use daemon; then
		newconfd "${FILESDIR}"/amuled.confd-r1 amuled
		newinitd "${FILESDIR}"/amuled.initd amuled
	fi
	if use remote; then
		newconfd "${FILESDIR}"/amuleweb.confd-r1 amuleweb
		newinitd "${FILESDIR}"/amuleweb.initd amuleweb
	fi

	if use daemon || use remote; then
		keepdir /var/lib/${PN}
		fowners amule:amule /var/lib/${PN}
		fperms 0750 /var/lib/${PN}
	fi
}

pkg_postinst() {
	if use daemon || use remote && ver_replacing -lt "2.3.2-r4"; then
		elog "Default user under which amuled and amuleweb daemons are started"
		elog "have been changed from p2p to amule. Default home directory have been"
		elog "changed as well."
		echo
		elog "If you want to preserve old download/share location, you can create"
		elog "symlink /var/lib/amule/.aMule pointing to the old location and adjust"
		elog "files ownership *or* restore AMULEUSER and AMULEHOME variables in"
		elog "/etc/conf.d/{amuled,amuleweb} to the old values."
	fi

	use gui && xdg_desktop_database_update
}

pkg_postrm() {
	use gui && xdg_desktop_database_update
}
