# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit eutils python-r1

DESCRIPTION="A utility to find various forms of lint on a filesystem"
HOMEPAGE="http://www.pixelbeat.org/fslint/"
SRC_URI="http://www.pixelbeat.org/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"

IUSE="nls"

RDEPEND="${PYTHON_DEPS}
	dev-python/pygtk:2[${PYTHON_USEDEP}]
	gnome-base/libglade:2.0"

DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext:* )"

src_prepare() {
	# Change some paths to make ${PN}-gui run when installed in /usr/bin.
	sed -e "s:^liblocation=.*$:liblocation='${EROOT}usr/share/${PN}' #Gentoo:" \
		-e "s:^locale_base=.*$:locale_base=None #Gentoo:" \
		-i ${PN}-gui || die
}

src_install() {
	share=/usr/share/${PN}

	insinto ${share}
	doins ${PN}{.glade,.gladep,_icon.png}

	exeinto ${share}/${PN}
	doexe ${PN}/find*
	doexe ${PN}/${PN}
	doexe ${PN}/zipdir

	exeinto ${share}/${PN}/fstool/
	doexe ${PN}/fstool/*

	exeinto ${share}/${PN}/supprt/
	doexe ${PN}/supprt/{fslver,getffl,getffp,getfpf,md5sum_approx}

	exeinto ${share}/${PN}/supprt/rmlint
	doexe ${PN}/supprt/rmlint/*

	dobin ${PN}-gui

	doicon ${PN}_icon.png
	domenu ${PN}.desktop

	dodoc doc/{FAQ,NEWS,README,TODO}
	doman man/${PN}{.1,-gui.1}

	if use nls ; then
		cd po
		emake DESTDIR="${D}" install
	fi

	# Fix Python shebangs.
	python_replicate_script "${ED}"${share}/${PN}/fstool/dupwaste
	python_replicate_script "${ED}"${share}/${PN}/supprt/md5sum_approx
	python_replicate_script "${ED}"${share}/${PN}/supprt/rmlint/merge_hardlinks
	python_replicate_script "${ED}"${share}/${PN}/supprt/rmlint/fixdup
	python_replicate_script "${ED}"/usr/bin/${PN}-gui
}
