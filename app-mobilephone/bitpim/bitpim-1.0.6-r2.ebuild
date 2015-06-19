# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-mobilephone/bitpim/bitpim-1.0.6-r2.ebuild,v 1.3 2015/04/08 07:30:35 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils fdo-mime multilib

DESCRIPTION="Program to view and manipulate data on LG VX4400/VX6000 and many Sanyo Sprint mobile phones"
HOMEPAGE="http://www.bitpim.org/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# this needs fixing
#KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="crypt evo usb"

COMMON_DEPEND="dev-python/apsw[${PYTHON_USEDEP}]
	dev-python/pyserial[${PYTHON_USEDEP}]
	dev-python/python-dsv[${PYTHON_USEDEP}]
	dev-python/wxpython:2.8[${PYTHON_USEDEP}]
	crypt? (
		>=dev-python/paramiko-1.7.1[${PYTHON_USEDEP}]
		dev-python/pycrypto[${PYTHON_USEDEP}]
	)
	usb? ( virtual/libusb:0 )"
DEPEND="${COMMON_DEPEND}
	usb? ( dev-lang/swig )"
RDEPEND="${COMMON_DEPEND}
	media-libs/netpbm
	virtual/ffmpeg"

PATCHES=( "${FILESDIR}/${P}-gentoo.patch" "${FILESDIR}/${P}-ffmpeg_quality.patch" "${FILESDIR}/${P}-gcc43.patch" )

src_prepare() {
	distutils-r1_src_prepare
	python_setup
	sed -i -e "s/^PYTHONVER=.*/PYTHONVER=\$PYTHON/" \
		src/native/usb/build.sh || die "sed failed"
	sed -i "s/\$(EXTRADEFINES)\ -O2/\$(CXXFLAGS) \$(LDFLAGS)/" \
		src/native/av/bmp2avi/Makefile || die "sed failed"
}

src_compile() {
	# USB stuff
	if use usb; then
	    cd "${S}/src/native/usb"
	    sh ./build.sh || die "compilation of native/usb failed"
	fi

	# strings
	cd "${S}/src/native/strings"
	distutils-r1_src_compile

	# bmp2avi
	cd "${S}/src/native/av/bmp2avi"
	PLATFORM=linux emake CXX="$(tc-getCXX)"
}

src_install() {

	# Install files into right place
	#
	# BitPim is a self-contained app, so jamming it into
	# Python's site-packages might not be worthwhile.  We'll
	# Put it in its own home, and add the PYTHONPATH in the
	# wrapper executables below.
	local RLOC=/usr/$(get_libdir)/${P}

	# Main Python source
	insinto ${RLOC}
	doins src/*.py

	# Phone specifics
	insinto ${RLOC}/phones
	doins src/phones/*.py

	# Native products
	insinto ${RLOC}/native
	doins src/native/*.py
	insinto ${RLOC}/native/qtopiadesktop
	doins src/native/qtopiadesktop/*.py
	insinto ${RLOC}/native/outlook
	doins src/native/outlook/*.py
	insinto ${RLOC}/native/egroupware
	doins src/native/egroupware/*.py
	if use evo ; then
		insinto ${RLOC}/native/evolution
		doins src/native/evolution/*.py
	fi

	# strings
	cd "${S}/src/native/strings"
	distutils-r1_src_install

	cd "${S}"
	insinto $RLOC/native/strings
	doins src/native/strings/__init__.py src/native/strings/jarowpy.py

	# usb
	if use usb; then
		insinto ${RLOC}/native/usb
		doins src/native/usb/*.py
		doins src/native/usb/*.so
	fi

	# Helpers and resources
	dobin src/native/av/bmp2avi/bmp2avi
	insinto ${RLOC}/resources
	doins resources/*

	# Bitfling
	if use crypt; then
		FLINGDIR="${RLOC}/bitfling"
		insinto $FLINGDIR
		cd "${S}/src/bitfling"
		doins *.py
		cd "${S}"
	fi

	# Creating scripts
	echo '#!/bin/sh' > "${T}/bitpim"
	echo "exec $PYTHON ${RLOC}/bp.py \"\$@\"" >> "${T}/bitpim"
	dobin "${T}/bitpim"
	if use crypt; then
		echo '#!/bin/sh' > "${T}/bitfling"
		echo "exec $PYTHON ${RLOC}/bp.py \"\$@\" bitfling" >> "${T}/bitfling"
		dobin "${T}/bitfling"
	fi

	# Desktop file
	sed -i \
		-e "s|%%INSTALLBINDIR%%|/usr/bin|" \
		-e "s|%%INSTALLLIBDIR%%|${RLOC}|" \
		-e "s|Terminal=0|Terminal=true|" \
		-e "s|Application;Calendar;ContactManagement;Utility;|Calendar;ContactManagement;Utility;|" \
		packaging/bitpim.desktop || die "sed failed"
	domenu packaging/bitpim.desktop
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
