# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils flag-o-matic autotools

SRC_REV="1"  # revision used by upstream

# HINTS:
# -> non-free modules are x86 and amd64 only
# -> iscan frontend needs non-free modules
# -> sane-epkowa should be usable on every arch
# -> ${P}-${SRC_REV}.tar.gz    (for gcc 3.2/3.3)
# -> ${P}-${SRC_REV}.c2.tar.gz (for gcc 3.4 or later)

# FIXME:
# Make jpeg/png optional. The problem is, that the configure script ignores --disable-*,
# if the corresponding lib is found on the system.
# Furthermore, iscan doesn't compile w/o libusb, this should be fixed somehow.

# TODO:
# (re)add closed-source binary modules which are needed for some scanners.

KEYWORDS="amd64 x86"

DESCRIPTION="EPSON Image Scan! for Linux (including sane-epkowa backend)"
HOMEPAGE="http://www.avasys.jp/english/linux_e/dl_scan.html"
SRC_URI="http://linux.avasys.jp/drivers/iscan/${PV}/${PN}_${PV}-${SRC_REV}.tar.gz
	doc? ( http://linux.avasys.jp/drivers/iscan/doc/userg_revL_e.pdf )"
LICENSE="GPL-2 AVASYS"
SLOT="0"

IUSE="X gimp jpeg png tiff doc"
IUSE_LINGUAS="ar de es fr it ja ko nl pt zh_CN zh_TW"

for X in ${IUSE_LINGUAS}; do IUSE="${IUSE} linguas_${X}"; done

QA_PRESTRIPPED="usr/$(get_libdir)/libesmod.so.*"
QA_TEXTRELS="${QA_PRESTRIPPED}"
QA_FLAGS_IGNORED="${QA_PRESTRIPPED}"

# Upstream ships broken sanity test
RESTRICT="test"

RDEPEND="media-gfx/iscan-data
	media-gfx/sane-backends
	virtual/udev
	virtual/libusb:0
	X? (
		x11-libs/gtk+:2
		gimp? ( media-gfx/gimp )
		png? ( media-libs/libpng )
		jpeg? ( virtual/jpeg )
		tiff? ( media-libs/tiff )
	)"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	X? ( sys-devel/gettext )"

src_prepare() {
	local i

	# convert japanese docs to UTF-8
	if use linguas_ja; then
		for i in {NEWS,README}.ja non-free/*.ja.txt; do
			if [ -f "${i}" ]; then
				echo ">>> Converting ${i} to UTF-8"
				iconv -f eucjp -t utf8 -o "${i}~" "${i}" && mv -f "${i}~" "${i}" || rm -f "${i}~"
			fi
		done
	fi

	# disable checks for gtk+
	if ! use X; then
		sed -i -e "s:PKG_CHECK_MODULES(GTK,.*):AC_DEFINE([HAVE_GTK_2], 0):g" \
			-e "s:\(PKG_CHECK_MODULES(GDK_IMLIB,.*)\):#\1:g" configure.ac
	fi

	epatch "${FILESDIR}"/iscan-2.25.0-drop-ltdl.patch
	epatch "${FILESDIR}"/iscan-2.25.0-fix-g++-test.patch
	epatch "${FILESDIR}"/iscan-2.26.2-libpng15.patch
	epatch "${FILESDIR}"/iscan-2.26.2-png-libs.patch

	eautoreconf
}

src_configure() {
	append-flags -D_GNU_SOURCE  # needed for 'strndup'
	local myconf="--enable-dependency-reduction"

	if use X; then
		myconf="${myconf}
			--enable-frontend
			$(use_enable gimp)
			$(use_enable jpeg)
			$(use_enable png)
			$(use_enable tiff)"
	else
		myconf="${myconf}
			--disable-frontend --disable-gimp
			--disable-jpeg --disable-png --disable-tiff"
	fi

	econf --disable-static ${myconf}
}

src_install() {
	local MY_LIB="/usr/$(get_libdir)"
	emake DESTDIR="${D}" install || die "emake install failed"

	# install docs
	dodoc AUTHORS NEWS README
	use linguas_ja && dodoc NEWS.ja README.ja

	# install sane config
	insinto /etc/sane.d
	doins backend/epkowa.conf

	# install extra docs
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins "${DISTDIR}/userg_revL_e.pdf"
	fi

	# link iscan so it is seen as a plugin in gimp
	if use X && use gimp; then
		local plugindir
		if [ -x /usr/bin/gimptool ]; then
			plugindir="$(gimptool --gimpplugindir)/plug-ins"
		elif [ -x /usr/bin/gimptool-2.0 ]; then
			plugindir="$(gimptool-2.0 --gimpplugindir)/plug-ins"
		else
			die "Can't find GIMP plugin directory."
		fi
		dodir "${plugindir}"
		dosym /usr/bin/iscan "${plugindir}"
	fi

	# install desktop entry
	if use X; then
		make_desktop_entry iscan "Image Scan! for Linux ${PV}" scanner
	fi
}

pkg_postinst() {
	local i
	local DLL_CONF="/etc/sane.d/dll.conf"
	local EPKOWA_CONF="/etc/sane.d/epkowa.conf"

	elog
	if grep -q "^[ \t]*\<epkowa\>" ${DLL_CONF}; then
		elog "Please edit ${EPKOWA_CONF} to suit your needs."
	elif grep -q "\<epkowa\>" ${DLL_CONF}; then
		elog "Hint: to enable the backend, add 'epkowa' to ${DLL_CONF}"
		elog "Then edit ${EPKOWA_CONF} to suit your needs."
	else
		echo "epkowa" >> ${DLL_CONF}
		elog "A new entry 'epkowa' was added to ${DLL_CONF}"
		elog "Please edit ${EPKOWA_CONF} to suit your needs."
	fi
}
