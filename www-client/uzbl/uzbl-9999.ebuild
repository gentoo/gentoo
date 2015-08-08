# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI='5'

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

if [[ ${PV} == *9999* ]]; then
	inherit git-2
	EGIT_REPO_URI=${EGIT_REPO_URI:-'git://github.com/Dieterbe/uzbl.git'}
	KEYWORDS=''
	SRC_URI=''
	IUSE='experimental'
	use experimental &&
		EGIT_BRANCH='next'
else
	inherit vcs-snapshot
	KEYWORDS='~amd64 ~x86 ~amd64-linux ~x86-linux'
	SRC_URI="http://github.com/Dieterbe/${PN}/tarball/${PV} -> ${P}.tar.gz"
fi

DESCRIPTION='Web interface tools which adhere to the unix philosophy.'
HOMEPAGE='http://www.uzbl.org'

LICENSE='LGPL-2.1 MPL-1.1'
SLOT='0'
IUSE+=' gtk3 +browser helpers +tabbed vim-syntax'

REQUIRED_USE='tabbed? ( browser )'

COMMON_DEPEND='
	dev-libs/glib:2
	>=dev-libs/icu-4.0.1
	>=net-libs/libsoup-2.24:2.4
	!gtk3? (
		>=net-libs/webkit-gtk-1.1.15:2
		>=x11-libs/gtk+-2.14:2
	)
	gtk3? (
		net-libs/webkit-gtk:3
		x11-libs/gtk+:3
	)
'

DEPEND="
	virtual/pkgconfig
	${COMMON_DEPEND}
"

RDEPEND="
	${COMMON_DEPEND}
	x11-misc/xdg-utils
	browser? (
		x11-misc/xclip
	)
	helpers? (
		dev-python/pygtk
		dev-python/pygobject:2
		gnome-extra/zenity
		net-misc/socat
		x11-libs/pango
		x11-misc/dmenu
		x11-misc/xclip
	)
	tabbed? (
		dev-python/pygtk
	)
	vim-syntax? ( || ( app-editors/vim app-editors/gvim ) )
"
# TODO document what requires the above helpers

PREFIX="${EPREFIX}/usr"

pkg_setup() {
	python-single-r1_pkg_setup
	if ! use helpers; then
		elog "uzbl's extra scripts use various optional applications:"
		elog
		elog '   dev-python/pygtk'
		elog '   dev-python/pygobject:2'
		elog '   gnome-extra/zenity'
		elog '   net-misc/socat'
		elog '   x11-libs/pango'
		elog '   x11-misc/dmenu'
		elog '   x11-misc/xclip'
		elog
		elog 'Make sure you emerge the ones you need manually.'
		elog 'You may also activate the *helpers* USE flag to'
		elog 'install all of them automatically.'
	else
		einfo 'You have enabled the *helpers* USE flag that installs'
		einfo "various optional applications used by uzbl's extra scripts."
	fi
}

src_prepare() {
	# remove -ggdb
	sed -i 's/-ggdb //g' Makefile ||
		die '-ggdb removal sed failed'

	# make gtk3 configurable
	sed -r 's:^(USE_GTK3) = (.*):\1?=\2:' -i Makefile ||
		die 'Makefile sed for gtk3 failed'

	# specify python version
	python_fix_shebang bin/uzbl-tabbed ||
		die 'Fix shebang failed'

	# fix sandbox
	if [ ${PV} == 9999 ] && ! use experimental
	then
		sed -i 's/prefix=$(PREFIX)/prefix=$(DESTDIR)\/$(PREFIX)/' Makefile ||
			die 'Makefile sed for sandbox failed'
	fi

	# fix QA of uzbl.desktop
	if [ ${PV} == 9999 ] && use experimental
	then
		sed -i 's/Categories=Application;Network;/Categories=Network;/'	\
			uzbl.desktop.in || die 'QA compliance of uzbl.desktop.in failed'
	fi
}

src_compile() {
	[[ ${PV} == 9999 ]] && gtk_var='ENABLE_GTK3' || gtk_var='USE_GTK3'
	emake PREFIX="${PREFIX}" ${gtk_var}=$(use gtk3 && echo 1 || echo 0)
}

src_install() {
	local targets='install-uzbl-core'
	use browser && targets="${targets} install-uzbl-browser"
	use browser && use tabbed && targets="${targets} install-uzbl-tabbed"

	# -j1 : upstream bug #351
	emake -j1 DESTDIR="${D}" PREFIX="${PREFIX}"	\
		DOCDIR="${ED}/usr/share/doc/${PF}" ${targets}

	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/ftdetect
		doins "${S}"/extras/vim/ftdetect/uzbl.vim

		insinto /usr/share/vim/vimfiles/syntax
		doins "${S}"/extras/vim/syntax/uzbl.vim
	fi
}
