# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )
PYTHON_REQ_USE="threads"

inherit eutils fdo-mime flag-o-matic prefix python-single-r1

DESCRIPTION="Qt GUI version of the Vim text editor"
HOMEPAGE="https://bitbucket.org/equalsraf/vim-qt/wiki/Home"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI=(
		"https://bitbucket.org/equalsraf/${PN}.git"
		"https://github.com/equalsraf/${PN}.git"
	)
	KEYWORDS=""
else
	SRC_URI="https://github.com/equalsraf/${PN}/archive/package-${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S=${WORKDIR}/${PN}-package-${PV}
fi

LICENSE="vim"
SLOT="0"
IUSE="acl cscope debug lua luajit nls perl python racket ruby"

REQUIRED_USE="luajit? ( lua )
	python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	>=app-editors/vim-core-7.4.560[acl?]
	>=app-eselect/eselect-vi-1.1.8
	>=dev-qt/qtcore-4.7.0:4
	>=dev-qt/qtgui-4.7.0:4
	sys-libs/ncurses
	acl? ( kernel_linux? ( sys-apps/acl ) )
	cscope? ( dev-util/cscope )
	lua? ( luajit? ( dev-lang/luajit )
		!luajit? ( dev-lang/lua[deprecated] ) )
	nls? ( virtual/libintl )
	perl? ( dev-lang/perl:= )
	python? ( ${PYTHON_DEPS} )
	racket? ( dev-scheme/racket )
	ruby? ( || ( dev-lang/ruby:2.0 dev-lang/ruby:1.9 ) )"
DEPEND="${RDEPEND}
	dev-util/ctags
	sys-devel/autoconf
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

pkg_setup() {
	export LC_COLLATE="C" # prevent locale brokenness
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	# Read vimrc from /etc/vim/
	echo '#define SYS_VIMRC_FILE "'${EPREFIX}'/etc/vim/vimrc"' >> "${S}"/src/feature.h
}

src_configure() {
	use debug && append-flags "-DDEBUG"

	local myconf="--with-features=huge --disable-gpm --enable-multibyte"
	myconf+=" $(use_enable acl)"
	myconf+=" $(use_enable cscope)"
	myconf+=" $(use_enable nls)"
	myconf+=" $(use_enable lua luainterp)"
	myconf+=" $(use_with luajit)"
	myconf+=" $(use_enable perl perlinterp)"
	myconf+=" $(use_enable racket mzschemeinterp)"
	myconf+=" $(use_enable ruby rubyinterp)"

	if ! use cscope ; then
		sed -i -e '/# define FEAT_CSCOPE/d' src/feature.h || die 'sed failed'
	fi

	# keep prefix env contained within the EPREFIX
	use prefix && myconf+=" --without-local-dir"

	if use python ; then
		if [[ ${EPYTHON} == python3* ]] ; then
			myconf+=" --enable-python3interp"
			export vi_cv_path_python3="${PYTHON}"
		else
			myconf+=" --enable-pythoninterp"
			export vi_cv_path_python="${PYTHON}"
		fi
	else
		myconf+=" --disable-pythoninterp --disable-python3interp"
	fi

	econf ${myconf} --enable-gui=qt --with-vim-name=qvim --with-modified-by=Gentoo-${PVR}
}

src_install() {
	dobin src/qvim
	dosym qvim /usr/bin/qvimdiff

	dodir /usr/share/man/man1
	echo ".so vim.1" > "${ED}"/usr/share/man/man1/qvim.1
	echo ".so vimdiff.1" > "${ED}"/usr/share/man/man1/qvimdiff.1

	# track https://bitbucket.org/equalsraf/vim-qt/issue/93/include-desktop-file-in-source
	# for inclusion of desktop file
	newmenu "${FILESDIR}"/vim-qt.desktop vim-qt.desktop
	doicon -s 64 src/qt/icons/vim-qt.png
}

pkg_postinst() {
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_mime_database_update
}
