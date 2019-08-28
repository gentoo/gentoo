# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop toolchain-funcs xdg-utils

MACROS_PV="20091017"
DESCRIPTION="Jasspa Microemacs"
HOMEPAGE="http://www.jasspa.com/"
SRC_URI="http://www.jasspa.com/release_20090909/jasspa-mesrc-${PV}.tar.gz
	!nanoemacs? (
		http://www.jasspa.com/release_20090909/jasspa-memacros-${MACROS_PV}.tar.gz
		http://www.jasspa.com/release_20090909/jasspa-mehtml-${PV}.tar.gz
		http://www.jasspa.com/release_20060909/meicons-extra.tar.gz )"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE="nanoemacs X xpm"

RDEPEND="sys-libs/ncurses:0=
	X? (
		x11-libs/libX11
		xpm? ( x11-libs/libXpm )
	)
	nanoemacs? ( !app-editors/ne )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	X? (
		x11-base/xorg-proto
		x11-libs/libXt
	)"

S="${WORKDIR}/me${PV:2}"
PATCHES=(
	"${FILESDIR}"/${PV}-ncurses.patch
	"${FILESDIR}"/${PV}-linux3.patch
)

src_unpack() {
	unpack jasspa-mesrc-${PV}.tar.gz
	if ! use nanoemacs; then
		mkdir "${WORKDIR}"/jasspa || die
		cd "${WORKDIR}"/jasspa || die
		# everything except jasspa-mesrc
		unpack ${A/jasspa-mesrc-${PV}.tar.gz/}
	fi
}

src_prepare() {
	default
	# allow for some variables to be passed to make
	sed -i -e \
		'/make/s/\$OPTIONS/& CC="$CC" COPTIMISE="$CFLAGS" LDFLAGS="$LDFLAGS" CONSOLE_LIBS="$CONSOLE_LIBS" STRIP=true/' \
		src/build || die "sed failed"
}

src_compile() {
	local pkgdatadir="${EPREFIX}/usr/share/jasspa"
	local me="" type=c
	use nanoemacs && me="-ne"
	use X && type=cw
	use xpm || export XPM_INCLUDE=.		# prevent Xpm autodetection

	cd src || die
	CC="$(tc-getCC)" \
	CONSOLE_LIBS="$("$(tc-getPKG_CONFIG)" --libs ncurses)" \
	./build ${me} \
		-t ${type} \
		-p "~/.jasspa:${pkgdatadir}/site:${pkgdatadir}" \
		|| die "build failed"
}

src_install() {
	local me=me type=c
	use nanoemacs && me=ne
	use X && type=cw
	newbin src/${me}${type} ${me}

	if ! use nanoemacs; then
		keepdir /usr/share/jasspa/site
		insinto /usr/share
		doins -r "${WORKDIR}"/jasspa
		use X && domenu "${FILESDIR}"/${PN}.desktop
	fi

	dodoc faq.txt readme.txt change.log
}

pkg_postinst() {
	use X && xdg_desktop_database_update
}

pkg_postrm() {
	use X && xdg_desktop_database_update
}
