# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV=${PV/_p/ga}
MY_P=${PN}-${MY_PV}
SUB_PV=${PV:0:3}
S="${WORKDIR}"/${PN}-${SUB_PV}

# Only the x3270 package installs fonts
FONT_PN="x3270"
FONT_S="${S}"/${FONT_PN}

inherit autotools font

DESCRIPTION="Complete 3270 (S390) access package"
HOMEPAGE="http://x3270.bgp.nu/"
SRC_URI="mirror://sourceforge/x3270/${MY_P}-src.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~s390 ~sparc ~x86"
IUSE="cjk doc gui ncurses ssl tcl"

RDEPEND="
	gui? (
		x11-libs/libX11
		x11-libs/libXaw
		x11-libs/libXmu
		x11-libs/libXt
	)
	ssl? ( dev-libs/openssl:= )
	ncurses? (
		sys-libs/ncurses:=
		sys-libs/readline:=
	)
	tcl? ( dev-lang/tcl:= )
"
DEPEND="
	${RDEPEND}
	gui? ( x11-base/xorg-proto )
"
BDEPEND="
	gui? (
		x11-apps/bdftopcf
		>=x11-apps/mkfontscale-1.2.0
		x11-misc/xbitmaps
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-4.1-musl-wint-t-fix.patch
	"${FILESDIR}"/${PN}-4.2_p5-ncurses-pkg-config.patch
)

src_prepare() {
	default

	# Some subdirs (like c3270/x3270/s3270) install the same set of data files
	# (they have the same contents).  Wrap that in a retry to avoid errors.
	cat <<-EOF > _install || die
	#!/bin/sh
	for n in 1 2 3 4 5; do
		install "\$@" && exit
		echo "retrying ..."
	done
	exit 1
	EOF
	chmod a+rx _install || die
	# Can't use the ${INSTALL} var as top level configure also uses it.
	# https://sourceforge.net/p/x3270/bugs/15/
	export ac_cv_path_install="${S}"/_install

	AT_NOEAUTOHEADER=yes eautoreconf
}

src_configure() {
	econf \
		--cache-file="${S}"/config.cache \
		--enable-s3270 \
		--enable-pr3287 \
		$(use_enable ncurses c3270) \
		$(use_enable tcl tcl3270) \
		$(use_enable gui x3270) \
		$(use_with gui x) \
		$(use_with gui fontdir "${FONTDIR}")
}

src_install() {
	use gui && dodir "${FONTDIR}"

	emake DESTDIR="${D}" install{,.man}

	use gui && font_src_install
}

pkg_postinst() {
	use gui && font_pkg_postinst
}

pkg_postrm() {
	use gui && font_pkg_postrm
}
