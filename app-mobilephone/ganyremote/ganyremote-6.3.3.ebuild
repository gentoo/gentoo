# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit autotools python-r1

DESCRIPTION="Gnome frontend to Anyremote"
HOMEPAGE="http://anyremote.sourceforge.net/"
SRC_URI="mirror://sourceforge/anyremote/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="bluetooth"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=app-mobilephone/anyremote-6.5[bluetooth=]
	dev-python/pygtk[${PYTHON_USEDEP}]
	bluetooth? ( dev-python/pybluez[${PYTHON_USEDEP}] )
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"

DOCS=( AUTHORS ChangeLog NEWS README )

src_prepare() {
	# using gettextize no-interactive example from dev-util/bless package
	cp $(type -p gettextize) "${T}"/ || die
	sed -i -e 's:read dummy < /dev/tty::' "${T}/gettextize" || die
	"${T}"/gettextize -f --no-changelog > /dev/null || die

	# remove deprecated entry
	sed -e "/Encoding=UTF-8/d" \
		-i ganyremote.desktop || die "fixing .desktop file failed"

	# fix documentation directory wrt bug #316087
	sed -i "s/doc\/${PN}/doc\/${PF}/g" Makefile.am || die
	eautoreconf

	# disable bluetooth check to avoid errors
	if ! use bluetooth ; then
		sed -e "s/usepybluez = True/usepybluez = False/" -i ganyremote || die
	fi
}

src_install() {
	default

	python_replicate_script "${D}"/usr/bin/ganyremote
}
