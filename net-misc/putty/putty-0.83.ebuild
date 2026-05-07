# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/putty-release.asc
inherit cmake desktop xdg-utils verify-sig

DESCRIPTION="A Free Telnet/SSH Client"
HOMEPAGE="https://www.chiark.greenend.org.uk/~sgtatham/putty/"
if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://git.tartarus.org/simon/putty.git"
else
	SRC_URI="
		https://the.earth.li/~sgtatham/${PN}/${PV}/${P}.tar.gz
		verify-sig? ( https://the.earth.li/~sgtatham/${PN}/${PV}/${P}.tar.gz.gpg )
	"
	KEYWORDS="~alpha ~amd64 ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi
SRC_URI+="https://dev.gentoo.org/~matthew/distfiles/${PN}-icons.tar.bz2"

LICENSE="MIT"
SLOT="0"
IUSE="debug doc +gtk gssapi"

RDEPEND="
	!net-misc/pssh
	gtk? (
		dev-libs/glib:2
		x11-libs/cairo
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:3[X]
		x11-libs/libX11
		x11-libs/pango
	)
	gssapi? ( virtual/krb5 )
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-lang/perl
	virtual/pkgconfig
	doc? ( app-text/halibut )
	verify-sig? ( ~sec-keys/openpgp-keys-putty-release-2023 )
"

src_unpack() {
	if [[ ${PV} == *9999 ]]; then
		git-r3_src_unpack
	else
		use verify-sig && verify-sig_verify_detached "${DISTDIR}"/${P}.tar.gz{,.gpg}
	fi
	default
}

src_prepare() {
	# ensure cmake_minimum_required >=3.10 (Bug: 964405)
	sed -i 's/VERSION 3\.7\.\.\.3\.28/VERSION 3.10...3.28/' CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	cd "${S}"/unix || die
	local mycmakeargs=(
		-DPUTTY_DEBUG="$(usex debug)"
		-DPUTTY_GSSAPI="$(usex gssapi DYNAMIC OFF)"
		-DPUTTY_GTK_VERSION=$(usex gtk 3 '')
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
