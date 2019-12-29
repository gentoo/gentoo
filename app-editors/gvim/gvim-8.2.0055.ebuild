# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VIM_VERSION="8.2"
PYTHON_COMPAT=( python{2_7,3_5,3_6,3_7} )
PYTHON_REQ_USE="threads(+)"
USE_RUBY="ruby24 ruby25 ruby26"

inherit vim-doc flag-o-matic xdg-utils gnome2-utils bash-completion-r1 prefix python-single-r1 ruby-single

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/vim/vim.git"
	EGIT_CHECKOUT_DIR=${WORKDIR}/vim-${PV}
else
	SRC_URI="https://github.com/vim/vim/archive/v${PV}.tar.gz -> vim-${PV}.tar.gz
		https://dev.gentoo.org/~radhermit/vim/vim-8.0.0938-gentoo-patches.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
fi

DESCRIPTION="GUI version of the Vim text editor"
HOMEPAGE="https://vim.sourceforge.io/ https://github.com/vim/vim"

SLOT="0"
LICENSE="vim"
IUSE="acl aqua cscope debug gtk gtk2 lua luajit motif neXt netbeans nls perl python racket ruby selinux session sound tcl"
REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
"

RDEPEND="
	>=app-eselect/eselect-vi-1.1
	>=sys-libs/ncurses-5.2-r2:0=
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libXext
	x11-libs/libXt
	acl? ( kernel_linux? ( sys-apps/acl ) )
	!aqua? (
		gtk? (
			x11-libs/gtk+:3
			x11-libs/libXft
		)
		!gtk? (
			gtk2? (
				>=x11-libs/gtk+-2.6:2
				x11-libs/libXft
			)
			!gtk2? (
				motif? ( >=x11-libs/motif-2.3:0 )
				!motif? (
					neXt? ( x11-libs/neXtaw )
					!neXt? ( x11-libs/libXaw )
				)
			)
		)
	)
	cscope? ( dev-util/cscope )
	lua? (
		luajit? ( dev-lang/luajit:2= )
		!luajit? ( dev-lang/lua:0[deprecated] )
	)
	nls? ( virtual/libintl )
	perl? ( dev-lang/perl:= )
	python? ( ${PYTHON_DEPS} )
	racket? ( dev-scheme/racket )
	ruby? ( ${RUBY_DEPS} )
	selinux? ( sys-libs/libselinux )
	session? ( x11-libs/libSM )
	sound? ( media-libs/libcanberra )
	tcl? ( dev-lang/tcl:0= )
"
DEPEND="${RDEPEND}
	sys-devel/autoconf
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"
# temporarily use PDEPEND to allow upgrades past icon file collision, bug #673880
PDEPEND="~app-editors/vim-core-${PV}"

# various failures (bugs #630042 and #682320)
RESTRICT="test"

S=${WORKDIR}/vim-${PV}

pkg_setup() {
	# people with broken alphabets run into trouble. bug 82186.
	unset LANG LC_ALL
	export LC_COLLATE="C"

	# Gnome sandbox silliness. bug #114475.
	mkdir -p "${T}"/home || die
	export HOME="${T}"/home

	use python && python-single-r1_pkg_setup
}

src_prepare() {
	if [[ ${PV} != 9999* ]]; then
		# Gentoo patches to fix runtime issues, cross-compile errors, etc
		eapply "${WORKDIR}"/patches/
	fi

	# Fixup a script to use awk instead of nawk
	sed -i -e \
		'1s|.*|#!'"${EPREFIX}"'/usr/bin/awk -f|' \
		"${S}"/runtime/tools/mve.awk || die "mve.awk sed failed"

	# Read vimrc and gvimrc from /etc/vim
	echo '#define SYS_VIMRC_FILE "'${EPREFIX}'/etc/vim/vimrc"' \
	    >> "${S}"/src/feature.h || die "echo failed"
	echo '#define SYS_GVIMRC_FILE "'${EPREFIX}'/etc/vim/gvimrc"' \
	    >> "${S}"/src/feature.h || die "echo failed"

	# Use exuberant ctags which installs as /usr/bin/exuberant-ctags.
	# Hopefully this pattern won't break for a while at least.
	# This fixes bug 29398 (27 Sep 2003 agriffis)
	sed -i -e \
		's/\<ctags\("\| [-*.]\)/exuberant-&/g' \
		"${S}"/runtime/doc/syntax.txt \
		"${S}"/runtime/doc/tagsrch.txt \
		"${S}"/runtime/doc/usr_29.txt \
		"${S}"/runtime/menu.vim \
		"${S}"/src/configure.ac || die 'sed failed'

	# Don't be fooled by /usr/include/libc.h.  When found, vim thinks
	# this is NeXT, but it's actually just a file in dev-libs/9libs
	# This fixes bug 43885 (20 Mar 2004 agriffis)
	sed -i -e \
		's/ libc\.h / /' "${S}"/src/configure.ac || die 'sed failed'

	# gcc on sparc32 has this, uhm, interesting problem with detecting EOF
	# correctly. To avoid some really entertaining error messages about stuff
	# which isn't even in the source file being invalid, we'll do some trickery
	# to make the error never occur. bug 66162 (02 October 2004 ciaranm)
	find "${S}" -name '*.c' | while read c; do
	    echo >> "$c" || die "echo failed"
	done

	# Try to avoid sandbox problems. Bug #114475.
	if [[ -d "${S}"/src/po ]]; then
		sed -i -e \
			'/-S check.vim/s,..VIM.,ln -s $(VIM) testvim \; ./testvim -X,' \
			"${S}"/src/po/Makefile || die
	fi

	cp -v "${S}"/src/config.mk.dist "${S}"/src/auto/config.mk || die "cp failed"

	# Bug #378107 - Build properly with >=perl-core/ExtUtils-ParseXS-3.20.0
	sed -i -e \
		"s:\\\$(PERLLIB)/ExtUtils/xsubpp:${EPREFIX}/usr/bin/xsubpp:" \
		"${S}"/src/Makefile || die 'sed for ExtUtils-ParseXS failed'

	eapply_user
}

src_configure() {
	local myconf=()

	# Fix bug 37354: Disallow -funroll-all-loops on amd64
	# Bug 57859 suggests that we want to do this for all archs
	filter-flags -funroll-all-loops

	# Fix bug 76331: -O3 causes problems, use -O2 instead. We'll do this for
	# everyone since previous flag filtering bugs have turned out to affect
	# multiple archs...
	replace-flags -O3 -O2

	# Fix bug 18245: Prevent "make" from the following chain:
	# (1) Notice configure.ac is newer than auto/configure
	# (2) Rebuild auto/configure
	# (3) Notice auto/configure is newer than auto/config.mk
	# (4) Run ./configure (with wrong args) to remake auto/config.mk
	sed -i -e \
		's# auto/config\.mk:#:#' src/Makefile || die "Makefile sed failed"
	rm -v src/auto/configure || die "rm failed"
	emake -j1 -C src autoconf

	# This should fix a sandbox violation (see bug 24447). The hvc
	# things are for ppc64, see bug 86433.
	local file
	for file in /dev/pty/s* /dev/console /dev/hvc/* /dev/hvc*; do
		if [[ -e ${file} ]]; then
			addwrite $file
		fi
	done

	use debug && append-flags "-DDEBUG"

	myconf=(
		--with-features=huge
		--disable-gpm
		--with-gnome=no
		$(use_enable sound canberra)
		$(use_enable acl)
		$(use_enable cscope)
		$(use_enable lua luainterp)
		$(use_with luajit)
		$(use_enable netbeans)
		$(use_enable nls)
		$(use_enable perl perlinterp)
		$(use_enable python pythoninterp)
		$(use_enable python python3interp)
		$(use_with python python-command $(type -P $(eselect python show --python2)))
		$(use_with python python3-command $(type -P $(eselect python show --python3)))
		$(use_enable racket mzschemeinterp)
		$(use_enable ruby rubyinterp)
		$(use_enable selinux)
		$(use_enable session xsmp)
		$(use_enable tcl tclinterp)
	)

	# --with-features=huge forces on cscope even if we --disable it. We need
	# to sed this out to avoid screwiness. (1 Sep 2004 ciaranm)
	if ! use cscope; then
		sed -i -e \
			'/# define FEAT_CSCOPE/d' src/feature.h || die "couldn't disable cscope"
	fi

	# gvim's GUI preference order is as follows:
	# aqua                         CARBON (not tested)
	# -aqua gtk                    GTK3
	# -aqua -gtk gtk2              GTK2
	# -aqua -gtk -gtk motif        MOTIF
	# -aqua -gtk -gtk -motif neXt  NEXTAW
	# -aqua -gtk -gtk -motif -neXt ATHENA
	echo ; echo
	if use aqua; then
		einfo "Building gvim with the Carbon GUI"
		myconf+=(
			--enable-darwin
			--enable-gui=carbon
		)
	elif use gtk; then
		myconf+=( --enable-gtk3-check )
		einfo "Building gvim with the gtk+-3 GUI"
		myconf+=( --enable-gui=gtk3 )
	elif use gtk2; then
		myconf+=( --enable-gtk2-check )
		einfo "Building gvim with the gtk+-2 GUI"
		myconf+=( --enable-gui=gtk2 )
	elif use motif; then
		einfo "Building gvim with the MOTIF GUI"
		myconf+=( --enable-gui=motif )
	elif use neXt; then
		einfo "Building gvim with the neXtaw GUI"
		myconf+=( --enable-gui=nextaw )
	else
		einfo "Building gvim with the Athena GUI"
		myconf+=( --enable-gui=athena )
	fi
	echo ; echo

	# let package manager strip binaries
	export ac_cv_prog_STRIP="$(type -P true ) faking strip"

	# keep prefix env contained within the EPREFIX
	use prefix && myconf+=( --without-local-dir )

	if [[ ${CHOST} == *-interix* ]]; then
		# avoid finding of this function, to avoid having to patch either
		# configure or the source, which would be much more hackish.
		# after all vim does it right, only interix is badly broken (again)
		export ac_cv_func_sigaction=no
	fi

	econf \
		--with-modified-by=Gentoo-${PVR} \
		--with-vim-name=gvim \
		--with-x \
		"${myconf[@]}"
}

src_compile() {
	# The following allows emake to be used
	emake -j1 -C src auto/osdef.h objects

	emake
}

src_test() {
	einfo
	einfo "Starting vim tests. Several error messages will be shown"
	einfo "while the tests run. This is normal behaviour and does not"
	einfo "indicate a fault."
	einfo
	ewarn "If the tests fail, your terminal may be left in a strange"
	ewarn "state. Usually, running 'reset' will fix this."
	einfo

	# Don't let vim talk to X
	unset DISPLAY

	# Make gvim not try to connect to X. See :help gui-x11-start in vim for how
	# this evil trickery works.
	ln -s "${S}"/src/gvim "${S}"/src/testvim || die

	# Make sure our VIMPROG is used.
	sed -i -e 's:\.\./vim:../testvim:' src/testdir/test49.vim || die

	# Don't do additional GUI tests.
	emake -j1 VIMPROG=../testvim -C src/testdir nongui
}

# Call eselect vi update with --if-unset
# to respect user's choice (bug 187449)
eselect_vi_update() {
	einfo "Calling eselect vi update..."
	eselect vi update --if-unset
	eend $?
}

src_install() {
	local vimfiles=/usr/share/vim/vim${VIM_VERSION/.}

	dobin src/gvim
	dosym gvim /usr/bin/gvimdiff
	dosym gvim /usr/bin/evim
	dosym gvim /usr/bin/eview
	dosym gvim /usr/bin/gview
	dosym gvim /usr/bin/rgvim
	dosym gvim /usr/bin/rgview

	emake -C src DESTDIR="${D}" DATADIR="${EPREFIX}"/usr/share install-icons

	dodir /usr/share/man/man1
	echo ".so vim.1" > "${ED}"/usr/share/man/man1/gvim.1 || die "echo failed"
	echo ".so vim.1" > "${ED}"/usr/share/man/man1/gview.1 || die "echo failed"
	echo ".so vimdiff.1" > "${ED}"/usr/share/man/man1/gvimdiff.1 || \
		die "echo failed"

	insinto /etc/vim
	newins "${FILESDIR}"/gvimrc-r1 gvimrc
	eprefixify "${ED}"/etc/vim/gvimrc

	# bash completion script, bug #79018.
	newbashcomp "${FILESDIR}"/${PN}-completion ${PN}

	# don't install vim desktop file
	rm -v "${ED}"/usr/share/applications/vim.desktop || die "failed to remove vim.desktop"
}

pkg_postinst() {
	# Update documentation tags (from vim-doc.eclass)
	update_vim_helptags

	# Update fdo mime stuff, bug #78394
	xdg_desktop_database_update

	# Update icon cache
	gnome2_icon_cache_update

	# Call eselect vi update
	eselect_vi_update
}

pkg_postrm() {
	# Update documentation tags (from vim-doc.eclass)
	update_vim_helptags

	# Update fdo mime stuff, bug #78394
	xdg_desktop_database_update

	# Update icon cache
	gnome2_icon_cache_update

	# Call eselect vi update
	eselect_vi_update
}
