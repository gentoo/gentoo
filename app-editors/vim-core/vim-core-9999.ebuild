# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/vim-core/vim-core-9999.ebuild,v 1.16 2015/06/18 06:30:59 radhermit Exp $

EAPI=5
VIM_VERSION="7.4"
inherit eutils vim-doc flag-o-matic versionator bash-completion-r1 prefix

MY_PV=${PV//./-}

if [[ ${PV} == 9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/vim/vim.git"
	EGIT_CHECKOUT_DIR=${WORKDIR}/vim-${MY_PV}
else
	SRC_URI="https://github.com/vim/vim/archive/v${MY_PV}.tar.gz -> vim-${PV}.tar.gz
		http://dev.gentoo.org/~radhermit/vim/vim-7.4.542-gentoo-patches.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

DESCRIPTION="vim and gvim shared files"
HOMEPAGE="http://www.vim.org/"

SLOT="0"
LICENSE="vim"
IUSE="nls acl minimal"

DEPEND="sys-devel/autoconf"
PDEPEND="!minimal? ( app-vim/gentoo-syntax )"

S=${WORKDIR}/vim-${MY_PV}

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
		sed -i -e \
			'/-S check.vim/s,..VIM.,ln -s $(VIM) testvim \; ./testvim -X,' \
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
	local myconf

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

	# Let Portage do the stripping. Some people like that.
	export ac_cv_prog_STRIP="$(type -P true ) faking strip"

	# Keep Gentoo Prefix env contained within the EPREFIX
	use prefix && myconf+=" --without-local-dir"

	econf \
		--with-modified-by=Gentoo-${PVR} \
		--enable-gui=no \
		--without-x \
		--disable-darwin \
		--disable-perlinterp \
		--disable-pythoninterp \
		--disable-rubyinterp \
		--disable-gpm \
		--disable-selinux \
		$(use_enable nls) \
		$(use_enable acl) \
		${myconf}
}

src_compile() {
	# The following allows emake to be used
	emake -j1 -C src auto/osdef.h objects

	emake tools
}

src_test() { :; }

src_install() {
	local vimfiles=/usr/share/vim/vim${VIM_VERSION/.}

	dodir /usr/{bin,share/{man/man1,vim}}
	cd src || die "cd src failed"
	emake \
		installruntime \
		installmanlinks \
		installmacros \
		installtutor \
		installtutorbin \
		installtools \
		install-languages \
		install-icons \
		DESTDIR="${D}" \
		BINDIR="${EPREFIX}"/usr/bin \
		MANDIR="${EPREFIX}"/usr/share/man \
		DATADIR="${EPREFIX}"/usr/share

	keepdir ${vimfiles}/keymap

	# default vimrc is installed by vim-core since it applies to
	# both vim and gvim
	insinto /etc/vim/
	newins "${FILESDIR}"/vimrc-r4 vimrc
	eprefixify "${ED}"/etc/vim/vimrc

	if use minimal ; then
		# To save space, install only a subset of the files.
		# Helps minimalize the livecd, bug 65144.
		eshopts_push -s extglob

		rm -fr "${ED}${vimfiles}"/{compiler,doc,ftplugin,indent}
		rm -fr "${ED}${vimfiles}"/{macros,print,tools,tutor}
		rm "${ED}"/usr/bin/vimtutor

		local keep_colors="default"
		ignore=$(rm -fr "${ED}${vimfiles}"/colors/!(${keep_colors}).vim )

		local keep_syntax="conf|crontab|fstab|inittab|resolv|sshdconfig"
		# tinkering with the next line might make bad things happen ...
		keep_syntax="${keep_syntax}|syntax|nosyntax|synload"
		ignore=$(rm -fr "${ED}${vimfiles}"/syntax/!(${keep_syntax}).vim )

		eshopts_pop
	fi

	# These files might have slight security issues, so we won't
	# install them. See bug #77841. We don't mind if these don't
	# exist.
	rm "${ED}${vimfiles}"/tools/{vimspell.sh,tcltags} 2>/dev/null

	newbashcomp "${FILESDIR}"/xxd-completion xxd

	# We shouldn't be installing the ex or view man page symlinks, as they
	# are managed by eselect-vi
	rm -f "${ED}"/usr/share/man/man1/{ex,view}.1
}

pkg_postinst() {
	# Update documentation tags (from vim-doc.eclass)
	update_vim_helptags
}

pkg_postrm() {
	# Update documentation tags (from vim-doc.eclass)
	update_vim_helptags
}
