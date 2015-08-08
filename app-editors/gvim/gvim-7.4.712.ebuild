# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
VIM_VERSION="7.4"
PYTHON_COMPAT=( python{2_7,3_3,3_4} )
PYTHON_REQ_USE=threads
inherit eutils vim-doc flag-o-matic fdo-mime versionator bash-completion-r1 prefix python-r1

if [[ ${PV} == 9999* ]] ; then
	inherit mercurial
	EHG_REPO_URI="https://vim.googlecode.com/hg/"
	EHG_PROJECT="vim"
else
	VIM_ORG_PATCH="vim-${PV}.patch.xz"
	SRC_URI="ftp://ftp.vim.org/pub/vim/unix/vim-${VIM_VERSION}.tar.bz2
		http://dev.gentoo.org/~radhermit/vim/${VIM_ORG_PATCH}
		http://dev.gentoo.org/~radhermit/vim/vim-7.4.542-gentoo-patches.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
fi

DESCRIPTION="GUI version of the Vim text editor"
HOMEPAGE="http://www.vim.org/"

SLOT="0"
LICENSE="vim"
IUSE="acl aqua cscope debug gnome gtk lua luajit motif neXt netbeans nls perl python racket ruby selinux session tcl"
REQUIRED_USE="
	luajit? ( lua )
	python? (
		|| ( $(python_gen_useflags '*') )
		?? ( $(python_gen_useflags 'python2*') )
		?? ( $(python_gen_useflags 'python3*') )
	)
"

RDEPEND="
	~app-editors/vim-core-${PV}
	>=app-eselect/eselect-vi-1.1
	>=sys-libs/ncurses-5.2-r2
	x11-libs/libXext
	x11-libs/libXt
	acl? ( kernel_linux? ( sys-apps/acl ) )
	!aqua? (
		gtk? (
			>=x11-libs/gtk+-2.6:2
			x11-libs/libXft
			gnome? ( >=gnome-base/libgnomeui-2.6 )
		)
		!gtk? (
			motif? ( >=x11-libs/motif-2.3:0 )
			!motif? (
				neXt? ( x11-libs/neXtaw )
				!neXt? ( x11-libs/libXaw )
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
	ruby? ( || ( dev-lang/ruby:2.2 dev-lang/ruby:2.1 dev-lang/ruby:2.0 ) )
	selinux? ( sys-libs/libselinux )
	session? ( x11-libs/libSM )
	tcl? ( dev-lang/tcl:0= )
"
DEPEND="${RDEPEND}
	dev-util/ctags
	sys-devel/autoconf
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

S=${WORKDIR}/vim${VIM_VERSION/.}

pkg_setup() {
	# people with broken alphabets run into trouble. bug 82186.
	unset LANG LC_ALL
	export LC_COLLATE="C"

	# Gnome sandbox silliness. bug #114475.
	mkdir -p "${T}"/home
	export HOME="${T}"/home
}

src_prepare() {
	if [[ ${PV} != 9999* ]] ; then
		if [[ -f "${WORKDIR}"/${VIM_ORG_PATCH%.xz} ]] ; then
			# Apply any patches available from vim.org for this version
			epatch "${WORKDIR}"/${VIM_ORG_PATCH%.xz}
		fi

		if [[ -d "${WORKDIR}"/patches/ ]]; then
			# Gentoo patches to fix runtime issues, cross-compile errors, etc
			EPATCH_SUFFIX="patch" EPATCH_FORCE="yes" \
				epatch "${WORKDIR}"/patches/
		fi
	fi

	# Fixup a script to use awk instead of nawk
	sed -i '1s|.*|#!'"${EPREFIX}"'/usr/bin/awk -f|' "${S}"/runtime/tools/mve.awk \
		|| die "mve.awk sed failed"

	# Read vimrc and gvimrc from /etc/vim
	echo '#define SYS_VIMRC_FILE "'${EPREFIX}'/etc/vim/vimrc"' >> "${S}"/src/feature.h
	echo '#define SYS_GVIMRC_FILE "'${EPREFIX}'/etc/vim/gvimrc"' >> "${S}"/src/feature.h

	# Use exuberant ctags which installs as /usr/bin/exuberant-ctags.
	# Hopefully this pattern won't break for a while at least.
	# This fixes bug 29398 (27 Sep 2003 agriffis)
	sed -i 's/\<ctags\("\| [-*.]\)/exuberant-&/g' \
		"${S}"/runtime/doc/syntax.txt \
		"${S}"/runtime/doc/tagsrch.txt \
		"${S}"/runtime/doc/usr_29.txt \
		"${S}"/runtime/menu.vim \
		"${S}"/src/configure.in || die 'sed failed'

	# Don't be fooled by /usr/include/libc.h.  When found, vim thinks
	# this is NeXT, but it's actually just a file in dev-libs/9libs
	# This fixes bug 43885 (20 Mar 2004 agriffis)
	sed -i 's/ libc\.h / /' "${S}"/src/configure.in || die 'sed failed'

	# gcc on sparc32 has this, uhm, interesting problem with detecting EOF
	# correctly. To avoid some really entertaining error messages about stuff
	# which isn't even in the source file being invalid, we'll do some trickery
	# to make the error never occur. bug 66162 (02 October 2004 ciaranm)
	find "${S}" -name '*.c' | while read c ; do echo >> "$c" ; done

	# Try to avoid sandbox problems. Bug #114475.
	if [[ -d "${S}"/src/po ]] ; then
		sed -i '/-S check.vim/s,..VIM.,ln -s $(VIM) testvim \; ./testvim -X,' \
			"${S}"/src/po/Makefile
	fi

	if version_is_at_least 7.3.122 ; then
		cp "${S}"/src/config.mk.dist "${S}"/src/auto/config.mk
	fi

	# Bug #378107 - Build properly with >=perl-core/ExtUtils-ParseXS-3.20.0
	if version_is_at_least 7.3 ; then
		sed -i "s:\\\$(PERLLIB)/ExtUtils/xsubpp:${EPREFIX}/usr/bin/xsubpp:"	\
			"${S}"/src/Makefile || die 'sed for ExtUtils-ParseXS failed'
	fi

	epatch_user
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
	# (1) Notice configure.in is newer than auto/configure
	# (2) Rebuild auto/configure
	# (3) Notice auto/configure is newer than auto/config.mk
	# (4) Run ./configure (with wrong args) to remake auto/config.mk
	sed -i 's# auto/config\.mk:#:#' src/Makefile || die "Makefile sed failed"
	rm -f src/auto/configure
	emake -j1 -C src autoconf

	# This should fix a sandbox violation (see bug 24447). The hvc
	# things are for ppc64, see bug 86433.
	for file in /dev/pty/s* /dev/console /dev/hvc/* /dev/hvc* ; do
		[[ -e ${file} ]] && addwrite $file
	done

	use debug && append-flags "-DDEBUG"

	myconf=(
		--with-features=huge
		--disable-gpm
		--enable-multibyte
		$(use_enable acl)
		$(use_enable cscope)
		$(use_enable lua luainterp)
		$(use_with luajit)
		$(use_enable netbeans)
		$(use_enable nls)
		$(use_enable perl perlinterp)
		$(use_enable racket mzschemeinterp)
		$(use_enable ruby rubyinterp)
		$(use_enable selinux)
		$(use_enable session xsmp)
		$(use_enable tcl tclinterp)
	)

	if use python ; then
		py_add_interp() {
			local v

			[[ ${EPYTHON} == python3* ]] && v=3
			myconf+=(
				--enable-python${v}interp
				vi_cv_path_python${v}="${PYTHON}"
			)
		}

		python_foreach_impl py_add_interp
	else
		myconf+=(
			--disable-pythoninterp
			--disable-python3interp
		)
	fi

	# --with-features=huge forces on cscope even if we --disable it. We need
	# to sed this out to avoid screwiness. (1 Sep 2004 ciaranm)
	if ! use cscope ; then
		sed -i '/# define FEAT_CSCOPE/d' src/feature.h || \
			die "couldn't disable cscope"
	fi

	# gvim's GUI preference order is as follows:
	# aqua                          CARBON (not tested)
	# -aqua gtk gnome               GNOME2
	# -aqua gtk -gnome              GTK2
	# -aqua -gtk  motif             MOTIF
	# -aqua -gtk -motif neXt        NEXTAW
	# -aqua -gtk -motif -neXt       ATHENA
	echo ; echo
	if use aqua ; then
		einfo "Building gvim with the Carbon GUI"
		myconf+=(
			--enable-darwin
			--enable-gui=carbon
		)
	elif use gtk ; then
		myconf+=( --enable-gtk2-check )
		if use gnome ; then
			einfo "Building gvim with the Gnome 2 GUI"
			myconf+=( --enable-gui=gnome2 )
		else
			einfo "Building gvim with the gtk+-2 GUI"
			myconf+=( --enable-gui=gtk2 )
		fi
	elif use motif ; then
		einfo "Building gvim with the MOTIF GUI"
		myconf+=( --enable-gui=motif )
	elif use neXt ; then
		einfo "Building gvim with the neXtaw GUI"
		myconf+=( --enable-gui=nextaw )
	else
		einfo "Building gvim with the Athena GUI"
		myconf+=( --enable-gui=athena )
	fi
	echo ; echo

	# Let Portage do the stripping. Some people like that.
	export ac_cv_prog_STRIP="$(type -P true ) faking strip"

	# Keep Gentoo Prefix env contained within the EPREFIX
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
	echo
	einfo "Starting vim tests. Several error messages will be shown"
	einfo "while the tests run. This is normal behaviour and does not"
	einfo "indicate a fault."
	echo
	ewarn "If the tests fail, your terminal may be left in a strange"
	ewarn "state. Usually, running 'reset' will fix this."
	echo

	# Don't let vim talk to X
	unset DISPLAY

	# We've got to call make test from within testdir, since the Makefiles
	# don't pass through our VIMPROG argument
	cd "${S}"/src/testdir

	# Test 49 won't work inside a portage environment
	einfo "Test 49 isn't sandbox-friendly, so it will be skipped."
	sed -i 's~test49.out~~g' Makefile

	# We don't want to rebuild vim before running the tests
	sed -i 's,: \$(VIMPROG),: ,' Makefile

	# Make gvim not try to connect to X. See :help gui-x11-start
	# in vim for how this evil trickery works.
	ln -s "${S}"/src/gvim "${S}"/src/testvim

	# Don't try to do the additional GUI test
	emake -j1 VIMPROG=../testvim nongui
}

# Make convenience symlinks, hopefully without stepping on toes.  Some
# of these links are "owned" by the vim ebuild when it is installed,
# but they might be good for gvim as well (see bug 45828)
update_vim_symlinks() {
	local f syms
	syms="vimdiff rvim rview"
	einfo "Calling eselect vi update..."
	# Call this with --if-unset to respect user's choice (bug 187449)
	eselect vi update --if-unset

	# Make or remove convenience symlink, vim -> gvim
	if [[ -f "${EROOT}"/usr/bin/gvim ]]; then
		ln -s gvim "${EROOT}"/usr/bin/vim 2>/dev/null
	elif [[ -L "${EROOT}"/usr/bin/vim && ! -f "${EROOT}"/usr/bin/vim ]]; then
		rm "${EROOT}"/usr/bin/vim
	fi

	# Make or remove convenience symlinks to vim
	if [[ -f "${EROOT}"/usr/bin/vim ]]; then
		for f in ${syms}; do
			ln -s vim "${EROOT}"/usr/bin/${f} 2>/dev/null
		done
	else
		for f in ${syms}; do
			if [[ -L "${EROOT}"/usr/bin/${f} && ! -f "${EROOT}"/usr/bin/${f} ]]; then
				rm -f "${EROOT}"/usr/bin/${f}
			fi
		done
	fi

	# This will still break if you merge then remove the vi package,
	# but there's only so much you can do, eh?  Unfortunately we don't
	# have triggers like are done in rpm-land.
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

	dodir /usr/share/man/man1
	echo ".so vim.1" > "${ED}"/usr/share/man/man1/gvim.1
	echo ".so vim.1" > "${ED}"/usr/share/man/man1/gview.1
	echo ".so vimdiff.1" > "${ED}"/usr/share/man/man1/gvimdiff.1

	insinto /etc/vim
	newins "${FILESDIR}"/gvimrc-r1 gvimrc
	eprefixify "${ED}"/etc/vim/gvimrc

	newmenu "${FILESDIR}"/gvim.desktop-r2 gvim.desktop
	doicon "${FILESDIR}"/gvim.xpm
	doicon -s scalable "${FILESDIR}"/gvim.svg

	# bash completion script, bug #79018.
	newbashcomp "${FILESDIR}"/${PN}-completion ${PN}

	# We shouldn't be installing the ex or view man page symlinks, as they
	# are managed by eselect-vi
	rm -f "${ED}"/usr/share/man/man1/{ex,view}.1
}

pkg_postinst() {
	# Update documentation tags (from vim-doc.eclass)
	update_vim_helptags

	# Update fdo mime stuff, bug #78394
	fdo-mime_mime_database_update

	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		echo
		elog "Vim 7 includes an integrated spell checker. You need to install"
		elog "word list files before you can use it. There are ebuilds for"
		elog "some of these named app-vim/vim-spell-*. If your language of"
		elog "choice is not included, please consult vim-spell.eclass for"
		elog "instructions on how to make a package."
		echo
		ewarn "Note that the English word lists are no longer installed by"
		ewarn "default."
		echo
	fi

	# Make convenience symlinks
	update_vim_symlinks
}

pkg_postrm() {
	# Update documentation tags (from vim-doc.eclass)
	update_vim_helptags

	# Update fdo mime stuff, bug #78394
	fdo-mime_mime_database_update

	# Make convenience symlinks
	update_vim_symlinks
}
