# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake desktop xdg-utils

DESCRIPTION="A Free Telnet/SSH Client"
HOMEPAGE="https://www.chiark.greenend.org.uk/~sgtatham/putty/"
SRC_URI="https://dev.gentoo.org/~matthew/distfiles/${PN}-icons.tar.bz2"
if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://git.tartarus.org/simon/putty.git"
else
	SRC_URI+=" https://the.earth.li/~sgtatham/${PN}/${PV}/${P}.tar.gz"
	KEYWORDS="~alpha amd64 ~arm64 ~hppa ppc ppc64 sparc x86"
fi
LICENSE="MIT"

SLOT="0"
IUSE="debug doc +gtk gtk2 gssapi"

RDEPEND="
	!net-misc/pssh
	gtk? (
		dev-libs/glib:2
		x11-libs/gdk-pixbuf
		x11-libs/libX11
		x11-libs/pango
		gtk2? ( x11-libs/gtk+:2 )
		!gtk2? ( x11-libs/gtk+:3[X] )
	)
	gssapi? ( virtual/krb5 )
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-lang/perl
	virtual/pkgconfig
	doc? ( app-doc/halibut )
"

REQUIRED_USE="
	gtk2? ( gtk )
"

PATCHES=(
	# Bug #873355
	"${FILESDIR}"/putty-0.77-nogssapi.patch
)

src_unpack() {
	[[ ${PV} == *9999 ]] && git-r3_src_unpack
	default
}

src_configure() {
	cd "${S}"/unix || die
	local mycmakeargs=(
		-DPUTTY_DEBUG="$(usex debug)"
		-DPUTTY_GSSAPI="$(usex gssapi DYNAMIC OFF)"
		-DPUTTY_GTK_VERSION=$(usex gtk $(usex gtk2 2 3 ) '')
		-DPUTTY_IPV6=yes
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile all doc
}

src_install() {
	cmake_src_install

	doman "${BUILD_DIR}"/doc/*.1

	if use doc ; then
		docinto html
		dodoc "${BUILD_DIR}"/doc/html/*.html
	fi

	if use gtk ; then
		local i
		for i in 16 22 24 32 48 64 128 256; do
			newicon -s ${i} \
				"${WORKDIR}"/${PN}-icons/${PN}-${i}.png \
				${PN}.png
		done

		# install desktop file provided by Gustav Schaffter in #49577
		make_desktop_entry ${PN} PuTTY ${PN} Network
	fi
}

pkg_postinst() {
	use gtk && xdg_icon_cache_update
}

pkg_postrm() {
	use gtk && xdg_icon_cache_update
}
