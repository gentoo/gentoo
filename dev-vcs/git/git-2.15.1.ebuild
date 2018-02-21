# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

GENTOO_DEPEND_ON_PERL=no

# bug #329479: git-remote-testgit is not multiple-version aware
PYTHON_COMPAT=( python2_7 )
PLOCALES="bg ca de es fr is it ko pt_PT ru sv vi zh_CN"
if [[ ${PV} == *9999 ]]; then
	SCM="git-r3"
	EGIT_REPO_URI="git://git.kernel.org/pub/scm/git/git.git"
	# Please ensure that all _four_ 9999 ebuilds get updated; they track the 4 upstream branches.
	# See https://git-scm.com/docs/gitworkflows#_graduation
	# In order of stability:
	# 9999-r0: maint
	# 9999-r1: master
	# 9999-r2: next
	# 9999-r3: pu
	case "${PVR}" in
		9999) EGIT_BRANCH=maint ;;
		9999-r1) EGIT_BRANCH=master ;;
		9999-r2) EGIT_BRANCH=next;;
		9999-r3) EGIT_BRANCH=pu ;;
	esac
fi

inherit toolchain-funcs eutils elisp-common l10n perl-module bash-completion-r1 python-single-r1 systemd ${SCM}

MY_PV="${PV/_rc/.rc}"
MY_P="${PN}-${MY_PV}"

DOC_VER=${MY_PV}

DESCRIPTION="stupid content tracker: distributed VCS designed for speed and efficiency"
HOMEPAGE="https://www.git-scm.com/"
if [[ ${PV} != *9999 ]]; then
	SRC_URI_SUFFIX="xz"
	SRC_URI_KORG="mirror://kernel/software/scm/git"
	[[ "${PV/rc}" != "${PV}" ]] && SRC_URI_KORG+='/testing'
	SRC_URI="${SRC_URI_KORG}/${MY_P}.tar.${SRC_URI_SUFFIX}
			${SRC_URI_KORG}/${PN}-manpages-${DOC_VER}.tar.${SRC_URI_SUFFIX}
			doc? (
			${SRC_URI_KORG}/${PN}-htmldocs-${DOC_VER}.tar.${SRC_URI_SUFFIX}
			)"
	[[ "${PV}" = *_rc* ]] || \
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x64-cygwin ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+blksha1 +curl cgi doc emacs gnome-keyring +gpg highlight +iconv libressl mediawiki mediawiki-experimental +nls +pcre +pcre-jit +perl +python ppcsha1 tk +threads +webdav xinetd cvs subversion test"

# Common to both DEPEND and RDEPEND
CDEPEND="
	gnome-keyring? ( app-crypt/libsecret )
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:= )
	sys-libs/zlib
	pcre? (
		pcre-jit? ( dev-libs/libpcre2[jit(+)] )
		!pcre-jit? ( dev-libs/libpcre )
	)
	perl? ( dev-lang/perl:=[-build(-)] )
	tk? ( dev-lang/tk:0= )
	curl? (
		net-misc/curl
		webdav? ( dev-libs/expat )
	)
	emacs? ( virtual/emacs )
"

RDEPEND="${CDEPEND}
	gpg? ( app-crypt/gnupg )
	mediawiki? (
		dev-perl/DateTime-Format-ISO8601
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
	python? ( ${PYTHON_DEPS} )
"

# This is how info docs are created with Git:
#   .txt/asciidoc --(asciidoc)---------> .xml/docbook
#   .xml/docbook  --(docbook2texi.pl)--> .texi
#   .texi         --(makeinfo)---------> .info
DEPEND="${CDEPEND}
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
	pcre-jit? ( pcre )
	python? ( ${PYTHON_REQUIRED_USE} )
"

PATCHES=(
	# bug #350330 - automagic CVS when we don't want it is bad.
	"${FILESDIR}"/git-2.12.0-optional-cvs.patch

	# install mediawiki perl modules also in vendor_dir
	# hack, needs better upstream solution
	"${FILESDIR}"/git-1.8.5-mw-vendor.patch

	"${FILESDIR}"/git-2.2.0-svn-fe-linking.patch

	# Bug #493306, where FreeBSD 10.x merged libiconv into its libc.
	"${FILESDIR}"/git-2.5.1-freebsd-10.x-no-iconv.patch
)

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
		myopts+=" BLK_SHA1=YesPlease"
	elif use ppcsha1 ; then
		myopts+=" PPC_SHA1=YesPlease"
	fi

	if use curl ; then
		use webdav || myopts+=" NO_EXPAT=YesPlease"
	else
		myopts+=" NO_CURL=YesPlease"
	fi

	# broken assumptions, because of static build system ...
	myopts+=" NO_FINK=YesPlease NO_DARWIN_PORTS=YesPlease"
	myopts+=" INSTALL=install TAR=tar"
	myopts+=" SHELL_PATH=${EPREFIX}/bin/sh"
	myopts+=" SANE_TOOL_PATH="
	myopts+=" OLD_ICONV="
	myopts+=" NO_EXTERNAL_GREP="

	# For svn-fe
	extlibs="-lz -lssl ${S}/xdiff/lib.a $(usex threads -lpthread '')"

	# can't define this to null, since the entire makefile depends on it
	sed -i -e '/\/usr\/local/s/BASIC_/#BASIC_/' Makefile

	use iconv \
		|| myopts+=" NO_ICONV=YesPlease"
	use nls \
		|| myopts+=" NO_GETTEXT=YesPlease"
	use tk \
		|| myopts+=" NO_TCLTK=YesPlease"
	if use pcre; then
		if use pcre-jit; then
			myopts+=" USE_LIBPCRE2=YesPlease"
			extlibs+=" -lpcre2-8"
		else
			myopts+=" USE_LIBPCRE1=YesPlease"
			myopts+=" NO_LIBPCRE1_JIT=YesPlease"
			extlibs+=" -lpcre"
		fi
	fi
	use perl \
		&& myopts+=" INSTALLDIRS=vendor" \
		|| myopts+=" NO_PERL=YesPlease"
	use python \
		|| myopts+=" NO_PYTHON=YesPlease"
	use subversion \
		|| myopts+=" NO_SVN_TESTS=YesPlease"
	use threads \
		&& myopts+=" THREADED_DELTA_SEARCH=YesPlease" \
		|| myopts+=" NO_PTHREADS=YesPlease"
	use cvs \
		|| myopts+=" NO_CVS=YesPlease"
	use elibc_musl \
		&& myopts+=" NO_REGEX=YesPlease"
# Disabled until ~m68k-mint can be keyworded again
#	if [[ ${CHOST} == *-mint* ]] ; then
#		myopts+=" NO_MMAP=YesPlease"
#		myopts+=" NO_IPV6=YesPlease"
#		myopts+=" NO_STRLCPY=YesPlease"
#		myopts+=" NO_MEMMEM=YesPlease"
#		myopts+=" NO_MKDTEMP=YesPlease"
#		myopts+=" NO_MKSTEMPS=YesPlease"
#	fi
	if [[ ${CHOST} == ia64-*-hpux* ]]; then
		myopts+=" NO_NSEC=YesPlease"
	fi
	if [[ ${CHOST} == *-*-aix* ]]; then
		myopts+=" NO_FNMATCH_CASEFOLD=YesPlease"
	fi
	if [[ ${CHOST} == *-solaris* ]]; then
		myopts+=" NEEDS_LIBICONV=YesPlease"
		myopts+=" HAVE_CLOCK_MONOTONIC=1"
		grep -q getdelim "${ROOT}"/usr/include/stdio.h && \
			myopts+=" HAVE_GETDELIM=1"
	fi

	has_version '>=app-text/asciidoc-8.0' \
		&& myopts+=" ASCIIDOC8=YesPlease"
	myopts+=" ASCIIDOC_NO_ROFF=YesPlease"

	# Bug 290465:
	# builtin-fetch-pack.c:816: error: 'struct stat' has no member named 'st_mtim'
	[[ "${CHOST}" == *-uclibc* ]] && \
		myopts+=" NO_NSEC=YesPlease"

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
		git-r3_src_unpack
		cd "${S}"
		#cp "${FILESDIR}"/GIT-VERSION-GEN .
	fi

}

src_prepare() {
	# add experimental patches to improve mediawiki support
	# see patches for origin
	if use mediawiki-experimental ; then
		PATCHES+=(
			"${FILESDIR}"/git-2.7.0-mediawiki-namespaces.patch
			"${FILESDIR}"/git-2.7.0-mediawiki-subpages.patch
			"${FILESDIR}"/git-2.7.0-mediawiki-500pages.patch
		)
	fi

	default

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
		PERL_PATH="${EPREFIX}/usr/bin/perl" \
		PERL_MM_OPT="" \
		GIT_TEST_OPTS="--no-color" \
		V=1 \
		"$@"
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
			gitweb \
			|| die "emake gitweb (cgi) failed"
	fi

	if [[ ${CHOST} == *-darwin* ]]; then
		cd "${S}"/contrib/credential/osxkeychain || die
		git_emake CC=$(tc-getCC) CFLAGS="${CFLAGS}" \
			|| die "emake credential-osxkeychain"
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
		cd "${S}"/contrib/credential/libsecret
		git_emake || die "emake git-credential-libsecret failed"
	fi

	cd "${S}"/contrib/subtree || die
	git_emake
	use doc && git_emake doc

	cd "${S}"/contrib/diff-highlight || die
	git_emake

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
	dodoc README* Documentation/{SubmittingPatches,CodingGuidelines}
	use doc && dodir /usr/share/doc/${PF}/html
	for d in / /howto/ /technical/ ; do
		docinto ${d}
		dodoc Documentation${d}*.txt
		if use doc ; then
			docinto ${d}/html
			dodoc Documentation${d}*.html
		fi
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
		cd "${S}"/contrib/credential/libsecret
		dobin git-credential-libsecret
	fi

	if use subversion ; then
		cd "${S}"/contrib/svn-fe
		dobin svn-fe
		dodoc svn-fe.txt
		if use doc ; then
			doman svn-fe.1
			docinto html
			dodoc svn-fe.html
		fi
		cd "${S}"
	fi

	dodir /usr/share/${PN}/contrib
	# The following are excluded:
	# completion - installed above
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
	local contrib_objects=(
		buildsystems
		fast-import
		hg-to-git
		hooks
		remotes2config.sh
		rerere-train.sh
		stats
		workdir
	)
	for i in "${contrib_objects[@]}" ; do
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
		systemd_newunit "${FILESDIR}/git-daemon_at-r1.service" "git-daemon@.service"
		systemd_dounit "${FILESDIR}/git-daemon.socket"
	fi

	perl_delete_localpod

	# Remove disabled linguas
	# we could remove sources in src_prepare, but install does not
	# handle missing locale dir well
	rm_loc() {
		if [[ -e "${ED}/usr/share/locale/${1}" ]]; then
			rm -r "${ED}/usr/share/locale/${1}" || die
		fi
	}
	l10n_for_each_disabled_locale_do rm_loc
}

src_test() {
	local disabled="t9128-git-svn-cmd-branch.sh"
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
