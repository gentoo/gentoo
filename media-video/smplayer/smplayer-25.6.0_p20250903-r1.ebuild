# Copyright 2007-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=1c32b339d484d5926ddb4ddf095f2ec30b7e44ca # only qt6 branch at this point
inherit optfeature qmake-utils toolchain-funcs xdg

DESCRIPTION="Great Qt GUI front-end for mplayer/mpv"
HOMEPAGE="https://www.smplayer.info/"
SRC_URI="https://github.com/smplayer-dev/${PN}/archive/${COMMIT}.tar.gz -> ${P}-${COMMIT:0:8}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-2+ BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~ppc ~ppc64 x86"
IUSE="bidi debug"

DEPEND="
	dev-qt/qt5compat:6
	dev-qt/qtbase:6=[dbus,gui,network,ssl,widgets,xml]
	dev-qt/qtdeclarative:6
	virtual/zlib:=
	x11-libs/libX11
"
RDEPEND="${DEPEND}
	|| (
		media-video/mpv[libass(+),X]
		media-video/mplayer[bidi?,libass,png,X]
	)
"
BDEPEND="dev-qt/qttools:6[linguist]"

PATCHES=(
	"${FILESDIR}/${PN}-17.1.0-advertisement_crap.patch"
	"${FILESDIR}/${PN}-18.2.0-jobserver.patch"
	"${FILESDIR}/${PN}-18.3.0-disable-werror.patch"
	"${FILESDIR}/${P}-disable-update-checker.patch" #bug #479902
	"${FILESDIR}/${P}-no-man-compress.patch"
	"${FILESDIR}/${P}-no-googledns.patch" # thx to Debian
)

src_prepare() {
	use bidi || PATCHES+=( "${FILESDIR}"/${PN}-16.4.0-zero-bidi.patch )

	default

	# Upstream Makefile sucks
	sed -i -e "/^PREFIX=/ s:/usr/local:${EPREFIX}/usr:" \
		-e "/^DOC_PATH=/ s:packages/smplayer:"${PF}":" \
		-e '/\.\/get_svn_revision\.sh/,+2c\
	cd src && $(DEFS) $(MAKE)' \
		Makefile || die

	# snapshot specialty: build wants an "SVN" revision...
	# use result of $ git rev-list --count HEAD
	echo "#define SVN_REVISION \"10395\"" > src/svn_revision.h
	echo "10395" > svn_revision

	# Turn debug message flooding off
	if ! use debug ; then
		sed -e 's:#\(DEFINES += NO_DEBUG_ON_CONSOLE\):\1:' \
			-i src/smplayer.pro || die
	fi
}

src_configure() {
	pushd src > /dev/null || die
		eqmake6 QT_MAJOR_VERSION=6
	popd > /dev/null || die
}

src_compile() {
	emake CC="$(tc-getCC)"

	pushd src/translations > /dev/null || die
		$(qt6_get_bindir)/lrelease ${PN}_*.ts
	popd > /dev/null || die
}

src_install() {
	# remove unneeded copies of the GPL
	rm Copying* docs/*/gpl.html || die
	# don't install empty dirs
	rmdir --ignore-fail-on-non-empty docs/* || die

	default
}

pkg_postinst() {
	xdg_pkg_postinst
	optfeature "URL support with media-video/mpv" net-misc/yt-dlp
}
