# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools desktop eutils git-r3

DESCRIPTION="The fast and light GNUstep window manager"
HOMEPAGE="http://www.windowmaker.org/"
SRC_URI="http://www.windowmaker.org/pub/source/release/WindowMaker-extra-0.1.tar.gz"
EGIT_REPO_URI="https://repo.or.cz/wmaker-crm.git"
EGIT_BRANCH="next"

SLOT="0"
LICENSE="GPL-2"
IUSE="gif imagemagick jpeg modelock nls png tiff webp xinerama +xpm xrandr"
KEYWORDS=""

DEPEND="media-libs/fontconfig
	>=x11-libs/libXft-2.1.0
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/libXt
	x11-libs/libXv
	gif? ( >=media-libs/giflib-4.1.0-r3 )
	imagemagick? ( >=media-gfx/imagemagick-7:0= )
	jpeg? ( virtual/jpeg:0= )
	png? ( media-libs/libpng:0= )
	tiff? ( media-libs/tiff:0 )
	webp? ( media-libs/libwebp )
	xinerama? ( x11-libs/libXinerama )
	xrandr? ( x11-libs/libXrandr )"
RDEPEND="${DEPEND}
	nls? ( >=sys-devel/gettext-0.10.39 )"

DOCS=( AUTHORS BUGFORM BUGS ChangeLog INSTALL INSTALL-WMAKER FAQ
	NEWS README README.definable-cursor README.i18n TODO )

src_unpack() {
	# wm-extras
	unpack ${A}

	git-r3_src_unpack
}

src_prepare() {
	# Fix some paths
	for file in WindowMaker/*menu* util/wmgenmenu.c; do
		if [[ -r $file ]] ; then
			sed -i -e "s|/usr/local/GNUstep/Applications/WPrefs.app|${EPREFIX}/usr/bin/|g;" "$file" || die
			sed -i -e "s|/usr/local/share/WindowMaker|${EPREFIX}/usr/share/WindowMaker|g;" "$file" || die
			sed -i -e "s|/opt/share/WindowMaker|${EPREFIX}/usr/share/WindowMaker|g;" "$file" || die
		fi;
	done;

	default
	eautoreconf
}

src_configure() {
	local myconf

	# image format types
	myconf="$(use_enable imagemagick magick) $(use_enable jpeg) $(use_enable gif) $(use_enable png) $(use_enable tiff) $(use_enable webp) $(use_enable xpm)"

	# non required X capabilities
	myconf="${myconf} $(use_enable modelock) $(use_enable xrandr randr) $(use_enable xinerama)"

	if use nls; then
		[[ -z $LINGUAS ]] && export LINGUAS="$(ls po/*.po | sed 's:po/\(.*\)\.po$:\1:' | xargs)"
	else
		myconf="${myconf} --disable-locale"
	fi

	# default settings with $myconf appended
	econf \
		--sysconfdir="${EPREFIX}"/etc/X11 \
		--with-x \
		--enable-usermenu \
		--with-pixmapdir="${EPREFIX}"/usr/share/pixmaps \
		--localedir="${EPREFIX}"/usr/share/locale \
		${myconf}

	pushd ../WindowMaker-extra-0.1 || die
	econf
}

src_compile() {
	emake

	# WindowMaker Extra Package (themes and icons)
	pushd ../WindowMaker-extra-0.1 || die
	emake
}

src_install() {
	default

	# WindowMaker Extra
	pushd ../WindowMaker-extra-0.1 || die
	emake DESTDIR="${D}" install

	newdoc README README.extra

	# create wmaker session shell script
	echo "#!/usr/bin/env bash" > wmaker
	echo "${EPREFIX}/usr/bin/wmaker" >> wmaker
	exeinto /etc/X11/Sessions/
	doexe wmaker

	insinto /usr/share/xsessions
	doins "${FILESDIR}"/wmaker.desktop
	make_desktop_entry /usr/bin/wmaker
}
