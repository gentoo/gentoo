# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="xml"
inherit eutils python-single-r1 toolchain-funcs udev user versionator

MY_PV=$(get_version_component_range 1-2)

DESCRIPTION="Application that rotates tablet pc's screen automatically, depending on orientation"
HOMEPAGE="https://launchpad.net/magick-rotation"
SRC_URI="http://launchpad.net/magick-rotation/trunk/${MY_PV}/+download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

DEPEND="${PYTHON_DEPS}
	x11-libs/libX11
	x11-libs/libXrandr"

RDEPEND="${DEPEND}
	dev-python/pygobject:2[${PYTHON_USEDEP}]
	dev-python/pygtk:2[${PYTHON_USEDEP}]
	dev-python/py-notify[${PYTHON_USEDEP}]
	x11-apps/xinput"

# there are no tests in package, default 'make check' does wrong things, bug #453672
RESTRICT="test"

pkg_setup() {
	python-single-r1_pkg_setup
	enewgroup magick
}

src_prepare() {
	# Remove unneeded files
	rm -r apt_* installer_gtk.py MAGICK-INSTALL gset_addkeyval.py MagickIcons/MagickSplash.png MagickUninstall || die 'removing unneeded files failed'

	# Fix Python shebangs
	python_fix_shebang "${S}"

	epatch_user
}

src_compile() {
	my_compile() {
		echo $(tc-getCC) $*
		$(tc-getCC) $* || die 'compilation failed'
	}

	local suffix=
	if use amd64; then
		suffix=64
	else
		suffix=32
	fi
	my_compile "${CFLAGS} ${LDFLAGS} check.c -lX11 -lXrandr -o checkmagick${suffix}"
}

src_install() {
	#TODO: add installation of GNOME Shell 3.2 extension
	dobin	checkmagick*

	udev_dorules 62-magick.rules

	insinto	/usr/share/${PN}
	doins	*.py

	insinto	/usr/share/${PN}/MagickIcons
	doins	MagickIcons/*.png

	exeinto /usr/share/${PN}
	doexe	magick-rotation
	doexe	xrotate.py

	dodoc *.txt ChangeLog

	make_desktop_entry /usr/share/${PN}/${PN} "Magick Rotation" /usr/share/${PN}/MagickIcons/magick-rotation-enabled.png "System;Utility;"
}

pkg_postinst() {
	optfeature() {
		elog "  [\e[1m$(has_version ${1} && echo I || echo ' ')\e[0m] ${1} (${2})"
	}

	elog
	elog "In order to use Magick Rotation with an on-screen keyboard and handwriting,"
	elog "the following additional package may also be installed for use at run-time:"
	elog
	optfeature 'media-gfx/cellwriter' "Magick Rotation's default onscreen keyboard"
	elog

	ewarn "in order to use Magick Rotation you have to be in the 'magick' group."
	ewarn "Just run 'gpasswd -a <USER> magick', then have <USER> re-login."
}
