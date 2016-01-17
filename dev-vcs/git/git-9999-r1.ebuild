# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

GENTOO_DEPEND_ON_PERL=no

# bug #329479: git-remote-testgit is not multiple-version aware
PYTHON_COMPAT=( python2_7 )
[[ ${PV} == *9999 ]] && SCM="git-2"
EGIT_REPO_URI="git://git.kernel.org/pub/scm/git/git.git"
EGIT_MASTER=maint

inherit toolchain-funcs eutils elisp-common perl-module bash-completion-r1 python-single-r1 systemd ${SCM}

MY_PV="${PV/_rc/.rc}"
MY_P="${PN}-${MY_PV}"

DOC_VER=${MY_PV}

DESCRIPTION="GIT - the stupid content tracker, the revision control system heavily used by the Linux kernel team"
HOMEPAGE="http://www.git-scm.com/"
if [[ ${PV} != *9999 ]]; then
	SRC_URI_SUFFIX="xz"
	SRC_URI_GOOG="https://git-core.googlecode.com/files"
	SRC_URI_KORG="mirror://kernel/software/scm/git"
	SRC_URI="${SRC_URI_GOOG}/${MY_P}.tar.${SRC_URI_SUFFIX}
			${SRC_URI_KORG}/${MY_P}.tar.${SRC_URI_SUFFIX}
			${SRC_URI_GOOG}/${PN}-manpages-${DOC_VER}.tar.${SRC_URI_SUFFIX}
			${SRC_URI_KORG}/${PN}-manpages-${DOC_VER}.tar.${SRC_URI_SUFFIX}
			doc? (
			${SRC_URI_KORG}/${PN}-htmldocs-${DOC_VER}.tar.${SRC_URI_SUFFIX}
			${SRC_URI_GOOG}/${PN}-htmldocs-${DOC_VER}.tar.${SRC_URI_SUFFIX}
			)"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~ia64-hpux ~x86-interix ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+blksha1 +curl cgi doc emacs gnome-keyring +gpg gtk highlight +iconv mediawiki mediawiki-experimental +nls +pcre +perl +python ppcsha1 tk +threads +webdav xinetd cvs subversion test"

# Common to both DEPEND and RDEPEND
CDEPEND="
	dev-libs/openssl:0
	sys-libs/zlib
	pcre? ( dev-libs/libpcre )
	perl? ( dev-lang/perl:=[-build(-)] )
	tk? ( dev-lang/tk:0 )
	curl? (
		net-misc/curl
		webdav? ( dev-libs/expat )
	)
	emacs? ( virtual/emacs )
	gnome-keyring? ( gnome-base/libgnome-keyring )"

RDEPEND="${CDEPEND}
	gpg? ( app-crypt/gnupg )
	mediawiki? (
		dev-perl/HTML-Tree
		dev-perl/MediaWiki-API
	)
	perl? ( dev-perl/Error
			dev-perl/Net-SMTP-SSL
			dev-perl/Authen-SASL
			cgi? ( dev-perl/CGI highlight? ( app-text/highlight ) )
			cvs? ( >=dev-vcs/cvsps-2.1:0 dev-perl/DBI dev-perl/DBD-SQLite )
			subversion? ( dev-vcs/subversion[-dso,perl] dev-perl/libwww-perl dev-perl/TermReadKey )
			)
	python? ( gtk?
	(
		>=dev-python/pygtk-2.8[${PYTHON_USEDEP}]
		>=dev-python/pygtksourceview-2.10.1-r1:2[${PYTHON_USEDEP}]
	)
		${PYTHON_DEPS} )"

# This is how info docs are created with Git:
#   .txt/asciidoc --(asciidoc)---------> .xml/docbook
#   .xml/docbook  --(docbook2texi.pl)--> .texi
#   .texi         --(makeinfo)---------> .info
DEPEND="${CDEPEND}
	app-arch/cpio
	doc? (
		app-text/asciidoc
		app-text/docbook2X
		sys-apps/texinfo
		app-text/xmlto
	)
	nls? ( sys-devel/gettext )
	test? (	app-crypt/gnupg	)"

# Live ebuild builds man pages and HTML docs, additionally
if [[ ${PV} == *9999 ]]; then
	DEPEND="${DEPEND}
		app-text/asciidoc"
fi

SITEFILE=50${PN}-gentoo.el
S="${WORKDIR}/${MY_P}"

REQUIRED_USE="
	cgi? ( perl )
	cvs? ( perl )
	mediawiki? ( perl )
	mediawiki-experimental? ( mediawiki )
	subversion? ( perl )
	webdav? ( curl )
	gtk? ( python )
	python? ( ${PYTHON_REQUIRED_USE} )
"

pkg_setup() {
	if use subversion && has_version "dev-vcs/subversion[dso]"; then
		ewarn "Per Gentoo bugs #223747, #238586, when subversion is built"
		ewarn "with USE=dso, there may be weird crashes in git-svn. You"
		ewarn "have been warned."
	fi
	if use python ; then
		python-single-r1_pkg_setup
	fi
}

# This is needed because for some obscure reasons future calls to make don't
# pick up these exports if we export them in src_unpack()
exportmakeopts() {
	local myopts

	if use blksha1 ; then
		myopts="${myopts} BLK_SHA1=YesPlease"
	elif use ppcsha1 ; then
		myopts="${myopts} PPC_SHA1=YesPlease"
	fi

	if use curl ; then
		use webdav || myopts="${myopts} NO_EXPAT=YesPlease"
	else
		myopts="${myopts} NO_CURL=YesPlease"
	fi

	# broken assumptions, because of broken build system ...
	myopts="${myopts} NO_FINK=YesPlease NO_DARWIN_PORTS=YesPlease"
	myopts="${myopts} INSTALL=install TAR=tar"
	myopts="${myopts} SHELL_PATH=${EPREFIX}/bin/sh"
	myopts="${myopts} SANE_TOOL_PATH="
	myopts="${myopts} OLD_ICONV="
	myopts="${myopts} NO_EXTERNAL_GREP="

	# For svn-fe
	extlibs="-lz -lssl ${S}/xdiff/lib.a $(usex threads -lpthread '')"

	# can't define this to null, since the entire makefile depends on it
	sed -i -e '/\/usr\/local/s/BASIC_/#BASIC_/' Makefile

	use iconv \
		|| myopts="${myopts} NO_ICONV=YesPlease"
	use nls \
		|| myopts="${myopts} NO_GETTEXT=YesPlease"
	use tk \
		|| myopts="${myopts} NO_TCLTK=YesPlease"
	use pcre \
		&& myopts="${myopts} USE_LIBPCRE=yes" \
		&& extlibs="${extlibs} -lpcre"
	use perl \
		&& myopts="${myopts} INSTALLDIRS=vendor" \
		|| myopts="${myopts} NO_PERL=YesPlease"
	use python \
		|| myopts="${myopts} NO_PYTHON=YesPlease"
	use subversion \
		|| myopts="${myopts} NO_SVN_TESTS=YesPlease"
	use threads \
		&& myopts="${myopts} THREADED_DELTA_SEARCH=YesPlease" \
		|| myopts="${myopts} NO_PTHREADS=YesPlease"
	use cvs \
		|| myopts="${myopts} NO_CVS=YesPlease"
# Disabled until ~m68k-mint can be keyworded again
#	if [[ ${CHOST} == *-mint* ]] ; then
#		myopts="${myopts} NO_MMAP=YesPlease"
#		myopts="${myopts} NO_IPV6=YesPlease"
#		myopts="${myopts} NO_STRLCPY=YesPlease"
#		myopts="${myopts} NO_MEMMEM=YesPlease"
#		myopts="${myopts} NO_MKDTEMP=YesPlease"
#		myopts="${myopts} NO_MKSTEMPS=YesPlease"
#	fi
	if [[ ${CHOST} == ia64-*-hpux* ]]; then
		myopts="${myopts} NO_NSEC=YesPlease"
	fi
	if [[ ${CHOST} == *-*-aix* ]]; then
		myopts="${myopts} NO_FNMATCH_CASEFOLD=YesPlease"
	fi
	if [[ ${CHOST} == *-solaris* ]]; then
		myopts="${myopts} NEEDS_LIBICONV=YesPlease"
	fi

	has_version '>=app-text/asciidoc-8.0' \
		&& myopts="${myopts} ASCIIDOC8=YesPlease"
	myopts="${myopts} ASCIIDOC_NO_ROFF=YesPlease"

	# Bug 290465:
	# builtin-fetch-pack.c:816: error: 'struct stat' has no member named 'st_mtim'
	[[ "${CHOST}" == *-uclibc* ]] && \
		myopts="${myopts} NO_NSEC=YesPlease"

	export MY_MAKEOPTS="${myopts}"
	export EXTLIBS="${extlibs}"
}

src_unpack() {
	if [[ ${PV} != *9999 ]]; then
		unpack ${MY_P}.tar.${SRC_URI_SUFFIX}
		cd "${S}"
		unpack ${PN}-manpages-${DOC_VER}.tar.${SRC_URI_SUFFIX}
		use doc && \
			cd "${S}"/Documentation && \
			unpack ${PN}-htmldocs-${DOC_VER}.tar.${SRC_URI_SUFFIX}
		cd "${S}"
	else
		git-2_src_unpack
		cd "${S}"
		#cp "${FILESDIR}"/GIT-VERSION-GEN .
	fi

}

src_prepare() {
	# bug #350330 - automagic CVS when we don't want it is bad.
	epatch "${FILESDIR}"/git-2.2.2-optional-cvs.patch

	# install mediawiki perl modules also in vendor_dir
	# hack, needs better upstream solution
	epatch "${FILESDIR}"/git-1.8.5-mw-vendor.patch

	# add experimental patches to improve mediawiki support
	# see patches for origin
	if use mediawiki-experimental ; then
		epatch "${FILESDIR}"/git-2.7.0-mediawiki-namespaces.patch
		epatch "${FILESDIR}"/git-2.7.0-mediawiki-subpages.patch
		epatch "${FILESDIR}"/git-2.7.0-mediawiki-500pages.patch
	fi

	epatch "${FILESDIR}"/git-2.2.0-svn-fe-linking.patch

	epatch_user

	sed -i \
		-e 's:^\(CFLAGS[[:space:]]*=\).*$:\1 $(OPTCFLAGS) -Wall:' \
		-e 's:^\(LDFLAGS[[:space:]]*=\).*$:\1 $(OPTLDFLAGS):' \
		-e 's:^\(CC[[:space:]]* =\).*$:\1$(OPTCC):' \
		-e 's:^\(AR[[:space:]]* =\).*$:\1$(OPTAR):' \
		-e "s:\(PYTHON_PATH[[:space:]]\+=[[:space:]]\+\)\(.*\)$:\1${EPREFIX}\2:" \
		-e "s:\(PERL_PATH[[:space:]]\+=[[:space:]]\+\)\(.*\)$:\1${EPREFIX}\2:" \
		Makefile contrib/svn-fe/Makefile || die "sed failed"

	# Never install the private copy of Error.pm (bug #296310)
	sed -i \
		-e '/private-Error.pm/s,^,#,' \
		perl/Makefile.PL

	# Fix docbook2texi command
	sed -r -i 's/DOCBOOK2X_TEXI[[:space:]]*=[[:space:]]*docbook2x-texi/DOCBOOK2X_TEXI = docbook2texi.pl/' \
		Documentation/Makefile || die "sed failed"

	# Fix git-subtree missing DESTDIR
	sed -i \
		-e '/$(INSTALL)/s/ $(libexecdir)/ $(DESTDIR)$(libexecdir)/g' \
		-e '/$(INSTALL)/s/ $(man1dir)/ $(DESTDIR)$(man1dir)/g'  \
		contrib/subtree/Makefile
}

git_emake() {
	# bug #326625: PERL_PATH, PERL_MM_OPT
	# bug #320647: PYTHON_PATH
	PYTHON_PATH=""
	use python && PYTHON_PATH="${PYTHON}"
	emake ${MY_MAKEOPTS} \
		DESTDIR="${D}" \
		OPTCFLAGS="${CFLAGS}" \
		OPTLDFLAGS="${LDFLAGS}" \
		OPTCC="$(tc-getCC)" \
		OPTAR="$(tc-getAR)" \
		prefix="${EPREFIX}"/usr \
		htmldir="${EPREFIX}"/usr/share/doc/${PF}/html \
		sysconfdir="${EPREFIX}"/etc \
		PYTHON_PATH="${PYTHON_PATH}" \
		PERL_MM_OPT="" \
		GIT_TEST_OPTS="--no-color" \
		V=1 \
		"$@"
	# This is the fix for bug #326625, but it also causes breakage, see bug
	# #352693.
	# PERL_PATH="${EPREFIX}/usr/bin/env perl" \
}

src_configure() {
	exportmakeopts
}

src_compile() {
	if use perl ; then
	git_emake perl/PM.stamp || die "emake perl/PM.stamp failed"
	git_emake perl/perl.mak || die "emake perl/perl.mak failed"
	fi
	git_emake || die "emake failed"

	if use emacs ; then
		elisp-compile contrib/emacs/git{,-blame}.el
	fi

	if use perl && use cgi ; then
		git_emake \
			gitweb/gitweb.cgi \
			|| die "emake gitweb/gitweb.cgi failed"
	fi

	if [[ ${CHOST} == *-darwin* ]]; then
		cd "${S}"/contrib/credential/osxkeychain || die "cd credential/osxkeychain"
		git_emake || die "emake credential-osxkeychain"
	fi

	cd "${S}"/Documentation
	if [[ ${PV} == *9999 ]] ; then
		git_emake man \
			|| die "emake man failed"
		if use doc ; then
			git_emake info html \
				|| die "emake info html failed"
		fi
	else
		if use doc ; then
			git_emake info \
				|| die "emake info html failed"
		fi
	fi

	if use subversion ; then
		cd "${S}"/contrib/svn-fe
		# by defining EXTLIBS we override the detection for libintl and
		# libiconv, bug #516168
		local nlsiconv=
		use nls && use !elibc_glibc && nlsiconv+=" -lintl"
		use iconv && use !elibc_glibc && nlsiconv+=" -liconv"
		git_emake EXTLIBS="${EXTLIBS} ${nlsiconv}" || die "emake svn-fe failed"
		if use doc ; then
			git_emake svn-fe.{1,html} || die "emake svn-fe.1 svn-fe.html failed"
		fi
		cd "${S}"
	fi

	if use gnome-keyring ; then
		cd "${S}"/contrib/credential/gnome-keyring
		git_emake || die "emake git-credential-gnome-keyring failed"
	fi

	cd "${S}"/contrib/subtree
	git_emake
	use doc && git_emake doc

	if use mediawiki ; then
		cd "${S}"/contrib/mw-to-git
		git_emake
	fi
}

src_install() {
	git_emake \
		install || \
		die "make install failed"

	if [[ ${CHOST} == *-darwin* ]]; then
		dobin contrib/credential/osxkeychain/git-credential-osxkeychain
	fi

	# Depending on the tarball and manual rebuild of the documentation, the
	# manpages may exist in either OR both of these directories.
	find man?/*.[157] >/dev/null 2>&1 && doman man?/*.[157]
	find Documentation/*.[157] >/dev/null 2>&1 && doman Documentation/*.[157]

	dodoc README Documentation/{SubmittingPatches,CodingGuidelines}
	use doc && dodir /usr/share/doc/${PF}/html
	for d in / /howto/ /technical/ ; do
		docinto ${d}
		dodoc Documentation${d}*.txt
		use doc && dohtml -p ${d} Documentation${d}*.html
	done
	docinto /
	# Upstream does not ship this pre-built :-(
	use doc && doinfo Documentation/{git,gitman}.info

	newbashcomp contrib/completion/git-completion.bash ${PN}
	bashcomp_alias git gitk
	# Not really a bash-completion file (bug #477920)
	# but still needed uncompressed (bug #507480)
	insinto /usr/share/${PN}
	doins contrib/completion/git-prompt.sh

	if use emacs ; then
		elisp-install ${PN} contrib/emacs/git.{el,elc}
		elisp-install ${PN} contrib/emacs/git-blame.{el,elc}
		#elisp-install ${PN}/compat contrib/emacs/vc-git.{el,elc}
		# don't add automatically to the load-path, so the sitefile
		# can do a conditional loading
		touch "${ED}${SITELISP}/${PN}/compat/.nosearch"
		elisp-site-file-install "${FILESDIR}"/${SITEFILE}
	fi

	if use python && use gtk ; then
		python_doscript "${S}"/contrib/gitview/gitview
		dodoc "${S}"/contrib/gitview/gitview.txt
	fi

	#dobin contrib/fast-import/git-p4 # Moved upstream
	#dodoc contrib/fast-import/git-p4.txt # Moved upstream
	newbin contrib/fast-import/import-tars.perl import-tars
	exeinto /usr/libexec/git-core/
	newexe contrib/git-resurrect.sh git-resurrect

	# git-subtree
	cd "${S}"/contrib/subtree
	git_emake install || die "Failed to emake install git-subtree"
	if use doc ; then
		git_emake install-man install-doc || die "Failed to emake install-doc install-mangit-subtree"
	fi
	newdoc README README.git-subtree
	dodoc git-subtree.txt
	cd "${S}"

	if use mediawiki ; then
		cd "${S}"/contrib/mw-to-git
		git_emake install
		cd "${S}"
	fi

	# diff-highlight
	dobin contrib/diff-highlight/diff-highlight
	newdoc contrib/diff-highlight/README README.diff-highlight

	# git-jump
	exeinto /usr/libexec/git-core/
	doexe contrib/git-jump/git-jump
	newdoc contrib/git-jump/README git-jump.txt

	# git-contacts
	exeinto /usr/libexec/git-core/
	doexe contrib/contacts/git-contacts
	dodoc contrib/contacts/git-contacts.txt

	if use gnome-keyring ; then
		cd "${S}"/contrib/credential/gnome-keyring
		dobin git-credential-gnome-keyring
	fi

	if use subversion ; then
		cd "${S}"/contrib/svn-fe
		dobin svn-fe
		dodoc svn-fe.txt
		use doc && doman svn-fe.1 && dohtml svn-fe.html
		cd "${S}"
	fi

	dodir /usr/share/${PN}/contrib
	# The following are excluded:
	# completion - installed above
	# credential/gnome-keyring TODO
	# diff-highlight - done above
	# emacs - installed above
	# examples - these are stuff that is not used in Git anymore actually
	# git-jump - done above
	# gitview - installed above
	# p4import - excluded because fast-import has a better one
	# patches - stuff the Git guys made to go upstream to other places
	# persistent-https - TODO
	# mw-to-git - TODO
	# subtree - build  seperately
	# svnimport - use git-svn
	# thunderbird-patch-inline - fixes thunderbird
	for i in \
		buildsystems convert-objects fast-import \
		hg-to-git hooks remotes2config.sh rerere-train.sh \
		stats workdir \
		; do
		cp -rf \
			"${S}"/contrib/${i} \
			"${ED}"/usr/share/${PN}/contrib \
			|| die "Failed contrib ${i}"
	done

	if use perl && use cgi ; then
		# We used to install in /usr/share/${PN}/gitweb
		# but upstream installs in /usr/share/gitweb
		# so we will install a symlink and use their location for compat with other
		# distros
		dosym /usr/share/gitweb /usr/share/${PN}/gitweb

		# INSTALL discusses configuration issues, not just installation
		docinto /
		newdoc  "${S}"/gitweb/INSTALL INSTALL.gitweb
		newdoc  "${S}"/gitweb/README README.gitweb

		find "${ED}"/usr/lib64/perl5/ \
			-name .packlist \
			-exec rm \{\} \;
	else
		rm -rf "${ED}"/usr/share/gitweb
	fi

	if ! use subversion ; then
		rm -f "${ED}"/usr/libexec/git-core/git-svn \
			"${ED}"/usr/share/man/man1/git-svn.1*
	fi

	if use xinetd ; then
		insinto /etc/xinetd.d
		newins "${FILESDIR}"/git-daemon.xinetd git-daemon
	fi

	if use !prefix ; then
		newinitd "${FILESDIR}"/git-daemon-r1.initd git-daemon
		newconfd "${FILESDIR}"/git-daemon.confd git-daemon
		systemd_newunit "${FILESDIR}/git-daemon_at.service" "git-daemon@.service"
		systemd_dounit "${FILESDIR}/git-daemon.socket"
	fi

	perl_delete_localpod
}

src_test() {
	local disabled=""
	local tests_cvs="t9200-git-cvsexportcommit.sh \
					t9400-git-cvsserver-server.sh \
					t9401-git-cvsserver-crlf.sh \
					t9402-git-cvsserver-refs.sh \
					t9600-cvsimport.sh \
					t9601-cvsimport-vendor-branch.sh \
					t9602-cvsimport-branches-tags.sh \
					t9603-cvsimport-patchsets.sh \
					t9604-cvsimport-timestamps.sh"
	local tests_perl="t3701-add-interactive.sh \
					t5502-quickfetch.sh \
					t5512-ls-remote.sh \
					t5520-pull.sh \
					t7106-reset-unborn-branch.sh \
					t7501-commit.sh"
	# Bug #225601 - t0004 is not suitable for root perm
	# Bug #219839 - t1004 is not suitable for root perm
	# t0001-init.sh - check for init notices EPERM*  fails
	local tests_nonroot="t0001-init.sh \
		t0004-unwritable.sh \
		t0070-fundamental.sh \
		t1004-read-tree-m-u-wf.sh \
		t3700-add.sh \
		t7300-clean.sh"
	# t9100 still fails with symlinks in SVN 1.7
	local test_svn="t9100-git-svn-basic.sh"

	# Unzip is used only for the testcase code, not by any normal parts of Git.
	if ! has_version app-arch/unzip ; then
		einfo "Disabling tar-tree tests"
		disabled="${disabled} t5000-tar-tree.sh"
	fi

	cvs=0
	use cvs && let cvs=$cvs+1
	if [[ ${EUID} -eq 0 ]]; then
		if [[ $cvs -eq 1 ]]; then
			ewarn "Skipping CVS tests because CVS does not work as root!"
			ewarn "You should retest with FEATURES=userpriv!"
			disabled="${disabled} ${tests_cvs}"
		fi
		einfo "Skipping other tests that require being non-root"
		disabled="${disabled} ${tests_nonroot}"
	else
		[[ $cvs -gt 0 ]] && \
			has_version dev-vcs/cvs && \
			let cvs=$cvs+1
		[[ $cvs -gt 1 ]] && \
			has_version "dev-vcs/cvs[server]" && \
			let cvs=$cvs+1
		if [[ $cvs -lt 3 ]]; then
			einfo "Disabling CVS tests (needs dev-vcs/cvs[USE=server])"
			disabled="${disabled} ${tests_cvs}"
		fi
	fi

	if ! use perl ; then
		einfo "Disabling tests that need Perl"
		disabled="${disabled} ${tests_perl}"
	fi

	einfo "Disabling tests that fail with SVN 1.7"
	disabled="${disabled} ${test_svn}"

	# Reset all previously disabled tests
	cd "${S}/t"
	for i in *.sh.DISABLED ; do
		[[ -f "${i}" ]] && mv -f "${i}" "${i%.DISABLED}"
	done
	einfo "Disabled tests:"
	for i in ${disabled} ; do
		[[ -f "${i}" ]] && mv -f "${i}" "${i}.DISABLED" && einfo "Disabled $i"
	done

	# Avoid the test system removing the results because we want them ourselves
	sed -e '/^[[:space:]]*$(MAKE) clean/s,^,#,g' \
		-i "${S}"/t/Makefile

	# Clean old results first, must always run
	cd "${S}/t"
	nonfatal git_emake clean

	# Now run the tests, keep going if we hit an error, and don't terminate on
	# failure
	cd "${S}"
	einfo "Start test run"
	#MAKEOPTS=-j1
	nonfatal git_emake --keep-going test
	rc=$?

	# Display nice results, now print the results
	cd "${S}/t"
	nonfatal git_emake aggregate-results

	# And bail if there was a problem
	[ $rc -eq 0 ] || die "tests failed. Please file a bug."
}

showpkgdeps() {
	local pkg=$1
	shift
	elog "  $(printf "%-17s:" ${pkg}) ${@}"
}

pkg_postinst() {
	use emacs && elisp-site-regen
	einfo "Please read /usr/share/bash-completion/git for Git bash command completion"
	einfo "Please read /usr/share/git/git-prompt.sh for Git bash prompt"
	einfo "Note that the prompt bash code is now in that separate script"
	elog "These additional scripts need some dependencies:"
	echo
	showpkgdeps git-quiltimport "dev-util/quilt"
	showpkgdeps git-instaweb \
		"|| ( www-servers/lighttpd www-servers/apache www-servers/nginx )"
	echo
	use mediawiki-experimental && ewarn "Using experimental git-mediawiki patches. The stability of cloned wiki filesystems is not guaranteed."
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
