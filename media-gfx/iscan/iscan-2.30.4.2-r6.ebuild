# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_DOC="userg_revQ"
inherit autotools desktop flag-o-matic

# HINTS:
# -> non-free modules are x86 and amd64 only
# -> iscan frontend needs non-free modules
# -> sane-epkowa should be usable on every arch
# -> ${P}-${SRC_REV}.tar.gz    (for gcc 3.2/3.3)
# -> ${P}-${SRC_REV}.c2.tar.gz (for gcc 3.4 or later)

# FIXME:
# iscan doesn't compile w/o libusb, this should be fixed somehow.

# TODO:
# (re)add closed-source binary modules which are needed for some scanners.

DESCRIPTION="EPSON Image Scan! for Linux (including sane-epkowa backend)"
HOMEPAGE="http://download.ebz.epson.net/dsc/search/01/search/?OSC=LX"
SRC_URI="http://support.epson.net/linux/src/scanner/iscan/${PN}_$(ver_rs 3 -).tar.gz
	doc? (
		https://dev.gentoo.org/~flameeyes/avasys/${MY_DOC}_e.pdf
		l10n_ja? ( https://dev.gentoo.org/~flameeyes/avasys/${MY_DOC}_j.pdf )
	)"
S="${WORKDIR}/${PN}-$(ver_cut 1-3)"

LICENSE="GPL-2 AVASYS"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc gimp l10n_ja nls X"

REQUIRED_USE="gimp? ( X )"

DEPEND="
	dev-libs/libltdl
	dev-libs/libxml2:2=
	media-gfx/sane-backends
	virtual/libusb:1
	virtual/udev
	gimp? ( media-gfx/gimp:0/2 )
	X? (
		dev-libs/glib:2
		media-libs/libjpeg-turbo:=
		media-libs/libpng:=
		media-libs/tiff:=
		x11-libs/gtk+:2
	)
"
RDEPEND="${DEPEND}
	media-gfx/iscan-data
"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"
# Upstream ships broken sanity test
RESTRICT="test"

DOCS=( AUTHORS NEWS README )

PATCHES=(
	"${FILESDIR}"/iscan-2.29.1-drop-ltdl.patch
	"${FILESDIR}"/iscan-2.28.1.3+libpng-1.5.patch
	"${FILESDIR}"/iscan-2.29.1-png-libs.patch
	"${FILESDIR}"/iscan-2.30.1-fix-g++-test.patch
	"${FILESDIR}"/iscan-2.30.1.1-gcc6.patch
	"${FILESDIR}"/iscan-2.30.3.1-fix-x86-unknown-types.patch
	"${FILESDIR}"/iscan-2.30.4.2-sscanf.patch
	"${FILESDIR}"/iscan-2.30.4.2-c99.patch
)

QA_PRESTRIPPED="usr/lib.*/libesmod.so.*"
QA_TEXTRELS="${QA_PRESTRIPPED}"
QA_FLAGS_IGNORED="${QA_PRESTRIPPED}"

src_prepare() {
	default

	if ! use X; then
		sed -i -e "s:PKG_CHECK_MODULES(GTK,.*):AC_DEFINE([HAVE_GTK_2], 0):g" \
			-e "s:\(PKG_CHECK_MODULES(GDK_IMLIB,.*)\):#\1:g" configure.ac || die
	fi

	eautoreconf
}

src_configure() {
	append-cppflags -D_GNU_SOURCE	# needed for 'strndup'
	replace-flags "-O[0-9s]" "-O1"	# fix selector box bug 388073

	# bug #963199
	append-cflags -std=gnu89

	local myeconfargs=(
		--enable-dependency-reduction
		--disable-static
		$(use_enable nls)
		$(use_enable gimp)
		$(use_enable X frontend)
		$(use_enable X jpeg)
		$(use_enable X png)
		$(use_enable X tiff)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	use l10n_ja && DOCS+=( {NEWS,README}.ja )
	use doc && DOCS+=( "${DISTDIR}/${MY_DOC}_$(usex l10n_ja j e).pdf" )
	default

	# install sane config
	insinto /etc/sane.d
	doins backend/epkowa.conf

	# link iscan so it is seen as a plugin in gimp
	local gimpplugindir
	local gimptool
	if use gimp; then
		for gimptool in gimptool gimptool-2.0; do
			if [[ -x /usr/bin/${gimptool} ]]; then
				einfo "Setting plugin link for GIMP version     $(/usr/bin/${gimptool} --version)"
				gimpplugindir=$(/usr/bin/${gimptool} --gimpplugindir)/plug-ins
				break
			fi
		done
		if [[ "/plug-ins" != "${gimpplugindir}" ]]; then
			dodir ${gimpplugindir}
			dosym ../../../../bin/iscan "${gimpplugindir}"/iscan
		else
			ewarn "No idea where to find the gimp plugin directory"
		fi
	fi

	use X && make_desktop_entry iscan "Image Scan! for Linux ${PV}" scanner

	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	local DLL_CONF="${EPREFIX}/etc/sane.d/dll.conf"
	local EPKOWA_CONF="${EPREFIX}/etc/sane.d/epkowa.conf"

	if grep -q "^[ \t]*\<epkowa\>" ${DLL_CONF}; then
		elog "Please edit ${EPKOWA_CONF} to suit your needs."
	elif grep -q "\<epkowa\>" ${DLL_CONF}; then
		elog "Hint: to enable the backend, add 'epkowa' to ${DLL_CONF}"
		elog "Then edit ${EPKOWA_CONF} to suit your needs."
	else
		echo "epkowa" >> ${DLL_CONF} || die
		elog "A new entry 'epkowa' was added to ${DLL_CONF}"
		elog "Please edit ${EPKOWA_CONF} to suit your needs."
	fi
}
