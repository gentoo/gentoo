# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/kanyremote/kanyremote-6.3.4.ebuild,v 1.3 2015/01/26 10:02:27 ago Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit autotools python-r1 base

DESCRIPTION="KDE frontend to Anyremote"
HOMEPAGE="http://anyremote.sourceforge.net/"
SRC_URI="mirror://sourceforge/anyremote/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="bluetooth"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=app-mobilephone/anyremote-6.0[bluetooth?]
	dev-python/PyQt4[X,${PYTHON_USEDEP}]
	kde-base/pykde4:4[${PYTHON_USEDEP}]
	bluetooth? ( dev-python/pybluez[${PYTHON_USEDEP}] )
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"

src_prepare() {
	# using gettextize no-interactive example from dev-util/bless package
	cp $(type -p gettextize) "${T}"/ || die
	sed -i -e 's:read dummy < /dev/tty::' "${T}/gettextize" || die
	"${T}"/gettextize -f --no-changelog > /dev/null || die

	# remove deprecated entry
	sed -e "/Encoding=UTF-8/d" \
		-i kanyremote.desktop || die "fixing .desktop file failed"

	# fix documentation directory wrt bug #316087
	sed -i "s/doc\/${PN}/doc\/${PF}/g" Makefile.am || die
	eautoreconf

	# disable bluetooth check to avoid errors
	if ! use bluetooth ; then
		sed -e "s/usepybluez    = True/usepybluez    = False/" -i kanyremote || die
	fi
}

src_install() {
	default

	python_replicate_script "${D}"/usr/bin/kanyremote
}
