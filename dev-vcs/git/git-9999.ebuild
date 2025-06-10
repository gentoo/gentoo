# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GENTOO_DEPEND_ON_PERL=no

# bug #329479: git-remote-testgit is not multiple-version aware
PYTHON_COMPAT=( python3_{11..14} )

inherit toolchain-funcs perl-module bash-completion-r1 optfeature plocale python-single-r1 systemd meson

PLOCALES="bg ca de es fr is it ko pt_PT ru sv vi zh_CN"

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://git.kernel.org/pub/scm/git/git.git"

	inherit git-r3
	# Please ensure that all _four_ 9999 ebuilds get updated; they track the 4 upstream branches.
	# See https://git-scm.com/docs/gitworkflows#_graduation
	# In order of stability:
	# 9999-r0: maint
	# 9999-r1: master
	# 9999-r2: next
	# 9999-r3: seen
	case ${PVR} in
		9999) EGIT_BRANCH=maint ;;
		9999-r1) EGIT_BRANCH=master ;;
		9999-r2) EGIT_BRANCH=next;;
		9999-r3) EGIT_BRANCH=seen ;;
	esac
fi

MY_PV="${PV/_rc/.rc}"
MY_P="${PN}-${MY_PV}"

DOC_VER="${MY_PV}"

DESCRIPTION="Stupid content tracker: distributed VCS designed for speed and efficiency"
HOMEPAGE="https://www.git-scm.com/"

if [[ ${PV} != *9999 ]]; then
	SRC_URI_SUFFIX="xz"
	SRC_URI_KORG="https://www.kernel.org/pub/software/scm/git"

	[[ ${PV/rc} != ${PV} ]] && SRC_URI_KORG+='/testing'

	SRC_URI="${SRC_URI_KORG}/${MY_P}.tar.${SRC_URI_SUFFIX}"
	SRC_URI+=" ${SRC_URI_KORG}/${PN}-manpages-${DOC_VER}.tar.${SRC_URI_SUFFIX}"
	SRC_URI+=" doc? ( ${SRC_URI_KORG}/${PN}-htmldocs-${DOC_VER}.tar.${SRC_URI_SUFFIX} )"

	if [[ ${PV} != *_rc* ]] ; then
		KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
	fi
fi

S="${WORKDIR}"/${MY_P}

LICENSE="GPL-2"
SLOT="0"
IUSE="+curl cgi cvs doc keyring +gpg highlight +iconv mediawiki +nls +pcre perforce +perl +safe-directory selinux subversion test tk +webdav xinetd"

# Common to both DEPEND and RDEPEND
DEPEND="
	dev-libs/openssl:=
	sys-libs/zlib
	curl? (
		net-misc/curl
		webdav? ( dev-libs/expat )
	)
	keyring? (
		app-crypt/libsecret
		dev-libs/glib:2
	)
	iconv? ( virtual/libiconv )
	pcre? ( dev-libs/libpcre2:= )
	perl? ( dev-lang/perl:=[-build(-)] )
	tk? ( dev-lang/tk:= )
"
RDEPEND="
	${DEPEND}
	gpg? ( app-crypt/gnupg )
	perl? (
		dev-perl/Error
		dev-perl/MailTools
		dev-perl/Authen-SASL
		>=virtual/perl-libnet-3.110.0-r4[ssl]
		cgi? (
			dev-perl/CGI
			highlight? ( app-text/highlight )
		)
		cvs? (
			>=dev-vcs/cvsps-2.1:0
			dev-perl/DBI
			dev-perl/DBD-SQLite
		)
		mediawiki? (
			dev-perl/DateTime-Format-ISO8601
			dev-perl/HTML-Tree
			dev-perl/MediaWiki-API
		)
		subversion? (
			dev-vcs/subversion[-dso(-),perl]
			dev-perl/libwww-perl
			dev-perl/TermReadKey
		)
	)
	perforce? ( ${PYTHON_DEPS} )
	selinux? ( sec-policy/selinux-git )
"

# This is how info docs are created with Git:
#   .txt/asciidoc --(asciidoc)---------> .xml/docbook
#   .xml/docbook  --(docbook2texi.pl)--> .texi
#   .texi         --(makeinfo)---------> .info
BDEPEND="
	doc? (
		app-text/asciidoc
		app-text/docbook2X
		app-text/xmlto
		sys-apps/texinfo
	)
	keyring? ( virtual/pkgconfig )
	nls? ( sys-devel/gettext )
	test? (
		app-arch/unzip
		app-crypt/gnupg
		dev-lang/perl
	)
"

# Live ebuild builds man pages and HTML docs, additionally
if [[ ${PV} == *9999 ]]; then
	BDEPEND+=" app-text/asciidoc"
fi

SITEFILE="50${PN}-gentoo.el"

REQUIRED_USE="
	cgi? ( perl )
	cvs? ( perl )
	mediawiki? ( perl )
	perforce? ( ${PYTHON_REQUIRED_USE} )
	subversion? ( perl )
	webdav? ( curl )
"

RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}"/${PN}-2.48.1-macos-no-fsmonitor.patch
	"${FILESDIR}"/${PN}-2.49.0-meson-use-test_environment-conditionally.patch

	# This patch isn't merged upstream but is kept in the ebuild by
	# demand from developers. It's opt-in (needs a config option)
	# and the documentation mentions that it is a Gentoo addition.
	"${FILESDIR}"/${PN}-2.49.0-diff-implement-config.diff.renames-copies-harder.patch
)

pkg_setup() {
	if use subversion && has_version "dev-vcs/subversion[dso]" ; then
		ewarn "Per Gentoo bugs #223747, #238586, when subversion is built"
		ewarn "with USE=dso, there may be weird crashes in git-svn. You"
		ewarn "have been warned!"
	fi

	if use perforce ; then
		python-single-r1_pkg_setup
	fi
}

src_unpack() {
	if [[ ${PV} != *9999 ]] ; then
		unpack ${MY_P}.tar.${SRC_URI_SUFFIX}

		cd "${S}" || die
		unpack ${PN}-manpages-${DOC_VER}.tar.${SRC_URI_SUFFIX}

		if use doc ; then
			pushd "${S}"/Documentation &>/dev/null || die
			unpack ${PN}-htmldocs-${DOC_VER}.tar.${SRC_URI_SUFFIX}
			popd &>/dev/null || die
		fi
	else
		git-r3_src_unpack
	fi

}

src_prepare() {
	if ! use safe-directory ; then
		# This patch neuters the "safe directory" detection.
		# bugs #838271, #838223
		PATCHES+=(
			"${FILESDIR}"/git-2.46.2-unsafe-directory.patch
		)
	fi

	default
}

src_configure() {
	local contrib=(
		completion
		subtree

		$(usev perl 'contacts')
	)
	local credential_helpers=(
		$(usev keyring 'libsecret')
		$(usev perl 'netrc')
	)

	# Needs macOS Frameworks that can't currently be built with GCC.
	if [[ ${CHOST} == *-darwin* ]] && tc-is-clang ; then
		credential_helpers+=( osxkeychain )
	fi

	local native_file="${T}"/meson.ini.local
	cat >> ${native_file} <<-EOF || die
	[binaries]
	# We don't want to bake /usr/bin/sh from usrmerged systems into
	# binaries. /bin/sh is required by POSIX.
	sh='/bin/sh'
	EOF

	local emesonargs=(
		--native-file "${native_file}"

		$(meson_feature curl)
		$(meson_feature cgi gitweb)
		$(meson_feature webdav expat)
		$(meson_feature iconv)
		$(meson_feature nls gettext)
		$(meson_feature pcre pcre2)
		$(meson_feature perl)
		$(meson_feature perforce python)
		$(meson_use test tests)

		-Dcontrib=$(IFS=, ; echo "${contrib[*]}" )
		-Dcredential_helpers=$(IFS=, ; echo "${credential_helpers[*]}" )

		-Dmacos_use_homebrew_gettext=false
		-Dperl_cpan_fallback=false
		# TODO: allow zlib-ng
		-Dzlib_backend=zlib
	)

	[[ ${CHOST} == *-darwin* ]] && emesonargs+=( -Dfsmonitor=false )

	# For non-live, we use a downloaded docs tarball instead.
	if [[ ${PV} == *9999 ]] || use doc ; then
		emesonargs+=(
			-Ddocs="man$(usev doc ',html')"
		)
	fi

	if [[ ${PV} != *9999 ]] ; then
		# Non-live ebuilds download the sources from a tarball which does not
		# include a .git directory.  Coccinelle assumes it exists and fails
		# otherwise.
		#
		# Fixes https://bugs.gentoo.org/952004
		emesonargs+=(
			-Dcoccinelle=disabled
		)
	fi

	meson_src_configure

	if use tk ; then
		(
			EMESON_SOURCE="${S}"/gitk-git
			BUILD_DIR="${WORKDIR}"/gitk-git_build
			emesonargs=()
			meson_src_configure
		)
	fi
}

git_emake() {
	local mymakeargs=(
		prefix="${EPREFIX}"/usr
		htmldir="${EPREFIX}"/usr/share/doc/${PF}/html
		sysconfdir="${EPREFIX}"/etc
		perllibdir="$(use perl && perl_get_raw_vendorlib)"

		CC="$(tc-getCC)"
		CFLAGS="${CFLAGS}"
		LDFLAGS="${LDFLAGS}"
		PKG_CONFIG="$(tc-getPKG_CONFIG)"
		OPTAR="$(tc-getAR)"
		OPTCC="$(tc-getCC)"
		OPTCFLAGS="${CFLAGS}"
		OPTLDFLAGS="${LDFLAGS}"

		PERL_PATH="${EPREFIX}/usr/bin/perl"
		PERL_MM_OPT=""

		V=1

		"$@"
	)

	emake "${mymakeargs[@]}"
}

src_compile() {
	meson_src_compile

	if use mediawiki ; then
		git_emake -C contrib/mw-to-git
	fi

	if use tk ; then
		git_emake -C git-gui gitexecdir="${EPREFIX}/usr/libexec/git-core"

		(
			EMESON_SOURCE="${S}"/gitk-git
			BUILD_DIR="${WORKDIR}"/gitk-git_build
			meson_src_compile
		)

	fi

	if use doc ; then
		# Workaround fragments that still use the Makefile and can't
		# find the bits from Meson's out-of-source build
		ln -s "${BUILD_DIR}"/Documentation/asciidoc.conf "${S}"/Documentation/asciidoc.conf || die
	fi

	git_emake -C contrib/diff-highlight
}

src_test() {
	# t0610-reftable-basics.sh uses $A
	local -x A=

	meson_src_test
}

src_install() {
	meson_src_install

	if use doc ; then
		cp -r "${ED}"/usr/share/doc/git-doc/. "${ED}"/usr/share/doc/${PF}/html || die
		rm -rf "${ED}"/usr/share/doc/git-doc/ || die
	fi

	# Depending on the tarball and manual rebuild of the documentation, the
	# manpages may exist in either OR both of these directories.
	find man?/*.[157] >/dev/null 2>&1 && doman man?/*.[157]
	find Documentation/*.[157] >/dev/null 2>&1 && doman Documentation/*.[157]
	dodoc README* Documentation/{SubmittingPatches,CodingGuidelines}

	local d
	for d in / /howto/ /technical/ ; do
		docinto ${d}
		dodoc Documentation${d}*.adoc
	done
	docinto /

	newbashcomp contrib/completion/git-completion.bash ${PN}
	bashcomp_alias git gitk
	# Not really a bash-completion file (bug #477920)
	# but still needed uncompressed (bug #507480)
	insinto /usr/share/${PN}
	doins contrib/completion/git-prompt.sh

	#dobin contrib/fast-import/git-p4 # Moved upstream
	#dodoc contrib/fast-import/git-p4.txt # Moved upstream
	newbin contrib/fast-import/import-tars.perl import-tars
	exeinto /usr/libexec/git-core/
	newexe contrib/git-resurrect.sh git-resurrect

	# diff-highlight
	dobin contrib/diff-highlight/diff-highlight
	newdoc contrib/diff-highlight/README README.diff-highlight

	# git-jump
	exeinto /usr/libexec/git-core/
	doexe contrib/git-jump/git-jump
	newdoc contrib/git-jump/README git-jump.txt

	dodir /usr/share/${PN}/contrib
	# The following are excluded:
	# completion - installed above
	# diff-highlight - done above
	# emacs - removed upstream
	# examples - these are stuff that is not used in Git anymore actually
	# git-jump - done above
	# gitview - installed above
	# p4import - excluded because fast-import has a better one
	# patches - stuff the Git guys made to go upstream to other places
	# persistent-https - TODO
	# mw-to-git - TODO
	# subtree - built seperately
	# svnimport - use git-svn
	# thunderbird-patch-inline - fixes thunderbird
	local contrib_objects=(
		buildsystems
		fast-import
		hooks
		remotes2config.sh
		rerere-train.sh
		stats
		workdir
	)
	local i
	for i in "${contrib_objects[@]}" ; do
		cp -rf "${S}"/contrib/${i} "${ED}"/usr/share/${PN}/contrib || die "Failed contrib ${i}"
	done

	if use cgi ; then
		# We used to install in /usr/share/${PN}/gitweb
		# but upstream installs in /usr/share/gitweb
		# so we will install a symlink and use their location for compat with other
		# distros
		dosym ../gitweb /usr/share/${PN}/gitweb

		# INSTALL discusses configuration issues, not just installation
		docinto /
		newdoc  "${S}"/gitweb/INSTALL INSTALL.gitweb
		newdoc  "${S}"/gitweb/README README.gitweb

		for d in "${ED}"/usr/lib{,64}/perl5/ ; do
			if [[ -d "${d}" ]] ; then
				find "${d}" -name .packlist -delete || die
			fi
		done
	else
		rm -rf "${ED}"/usr/share/gitweb
	fi

	if use perl ; then
		dodir "$(perl_get_vendorlib)"
		mv "${ED}"/usr/share/perl5/Git.pm "${ED}/$(perl_get_vendorlib)" || die
		mv "${ED}"/usr/share/perl5/Git "${ED}/$(perl_get_vendorlib)" || die
	fi

	if use mediawiki ; then
		git_emake -C contrib/mw-to-git DESTDIR="${D}" install
	fi

	if ! use subversion ; then
		rm -f "${ED}"/usr/libexec/git-core/git-svn \
			"${ED}"/usr/share/man/man1/git-svn.1*
	fi

	if use xinetd ; then
		insinto /etc/xinetd.d
		newins "${FILESDIR}"/git-daemon.xinetd git-daemon
	fi

	if ! use prefix ; then
		newinitd "${FILESDIR}"/git-daemon-r2.initd git-daemon
		newconfd "${FILESDIR}"/git-daemon.confd git-daemon
		systemd_newunit "${FILESDIR}/git-daemon_at-r1.service" "git-daemon@.service"
		systemd_dounit "${FILESDIR}/git-daemon.socket"
	fi

	if use tk ; then
		(
			EMESON_SOURCE="${S}"/gitk-git
			BUILD_DIR="${WORKDIR}"/gitk-git_build
			meson_src_install
		)

		git_emake -C git-gui gitexecdir="${EPREFIX}/usr/libexec/git-core" DESTDIR="${D}" install
	fi

	perl_delete_localpod

	# Remove disabled linguas
	# we could remove sources in src_prepare, but install does not
	# handle missing locale dir well
	rm_loc() {
		if [[ -e "${ED}/usr/share/locale/${1}" ]] ; then
			rm -r "${ED}/usr/share/locale/${1}" || die
		fi
	}
	plocale_for_each_disabled_locale rm_loc
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		elog "Please read /usr/share/bash-completion/completions/git for Git bash command"
		elog "completion."
		elog "Please read /usr/share/git/git-prompt.sh for Git bash prompt"
		elog "Note that the prompt bash code is now in that separate script"
	fi

	optfeature_header "Some scripts require additional dependencies:"
	optfeature git-quiltimport dev-util/quilt
	optfeature git-instaweb www-servers/lighttpd www-servers/apache www-servers/nginx
}
