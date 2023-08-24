# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit desktop git-r3

DESCRIPTION="The fast and light GNUstep window manager"
HOMEPAGE="https://www.windowmaker.org/"
SRC_URI="https://www.windowmaker.org/pub/source/release/WindowMaker-extra-0.1.tar.gz"
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
	jpeg? ( media-libs/libjpeg-turbo:= )
	nls? ( virtual/libintl )
	png? ( media-libs/libpng:= )
	tiff? ( media-libs/tiff:= )
	webp? ( media-libs/libwebp:= )
	xinerama? ( x11-libs/libXinerama )
	xrandr? ( x11-libs/libXrandr )"
RDEPEND="${DEPEND}"
BDEPEND="nls? ( >=sys-devel/gettext-0.10.39 )"

DOCS=( AUTHORS BUGFORM BUGS ChangeLog INSTALL-WMAKER FAQ
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
		fi
	done

	default
}

src_configure() {
	local -a myeconfargs=(
		# image format types
		$(use_enable gif)
		$(use_enable imagemagick magick)
		$(use_enable jpeg)
		$(use_enable png)
		$(use_enable tiff)
		$(use_enable webp)
		$(use_enable xpm)

		# optional X capabilities
		$(use_enable modelock)
		$(use_enable xinerama)
		$(use_enable xrandr randr)
	)

	# NLS depends on whether LINGUAS is empty
	if use nls; then
		myeconfargs+=( LINGUAS="${LINGUAS:-$(cd po; x=(*.po); echo ${x[*]%.po})}" )
	else
		myeconfargs+=( LINGUAS= )
	fi

	econf \
		--localedir="${EPREFIX}"/usr/share/locale \
		--sysconfdir="${EPREFIX}"/etc/X11 \
		--disable-static \
		--enable-usermenu \
		--with-{incs,libs}-from= \
		--with-pixmapdir="${EPREFIX}"/usr/share/pixmaps \
		--with-x \
		"${myeconfargs[@]}"

	pushd ../WindowMaker-extra-0.1 &>/dev/null || die
	econf
}

src_compile() {
	emake

	# WindowMaker Extra Package (themes and icons)
	emake -C ../WindowMaker-extra-0.1
}

src_install() {
	default

	# WindowMaker Extra
	emake -C ../WindowMaker-extra-0.1 DESTDIR="${D}" install
	newdoc ../WindowMaker-extra-0.1/README README.extra

	# create wmaker session shell script
	echo "#!/usr/bin/env bash" > wmaker
	echo "${EPREFIX}/usr/bin/wmaker" >> wmaker
	exeinto /etc/X11/Sessions/
	doexe wmaker

	insinto /usr/share/xsessions
	doins "${FILESDIR}"/wmaker.desktop
	make_desktop_entry /usr/bin/wmaker

	find "${ED}" -type f -name '*.la' -delete || die
}
