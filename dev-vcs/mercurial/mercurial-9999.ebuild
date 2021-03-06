# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
PYTHON_REQ_USE="threads(+)"
DISTUTILS_USE_SETUPTOOLS=no
CARGO_OPTIONAL=1

inherit bash-completion-r1 cargo elisp-common eutils distutils-r1 mercurial flag-o-matic

DESCRIPTION="Scalable distributed SCM"
HOMEPAGE="https://www.mercurial-scm.org/"
EHG_REPO_URI="https://www.mercurial-scm.org/repo/hg"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE="+chg emacs gpg test tk rust zsh-completion"

BDEPEND="
	dev-python/docutils[${PYTHON_USEDEP}]
	rust? ( ${RUST_DEPEND} )"

RDEPEND="
	app-misc/ca-certificates
	dev-python/zstandard[${PYTHON_USEDEP}]
	gpg? ( app-crypt/gnupg )
	tk? ( dev-lang/tk )
	zsh-completion? ( app-shells/zsh )"

DEPEND="emacs? ( >=app-editors/emacs-23.1:* )
	test? ( app-arch/unzip
		dev-python/pygments[${PYTHON_USEDEP}] )"

SITEFILE="70${PN}-gentoo.el"

# Too many tests fail #608720
RESTRICT="test"

src_unpack() {
	mercurial_src_unpack
	if use rust; then
		local S="${S}/rust/hg-cpython"
		cargo_live_src_unpack
	fi
}

python_prepare_all() {
	# fix up logic that won't work in Gentoo Prefix (also won't outside in
	# certain cases), bug #362891
	sed -i -e 's:xcodebuild:nocodebuild:' setup.py || die
	sed -i -e '/    hgenv =/a\' -e '    hgenv.pop("PYTHONPATH", None)' setup.py || die
	# Use absolute import for zstd
	sed -i -e 's/from \.* import zstd/import zstandard as zstd/' \
		mercurial/utils/compression.py \
		mercurial/wireprotoframing.py || die

	distutils-r1_python_prepare_all
}

src_compile() {
	if use rust; then
		pushd rust/hg-cpython || die
		cargo_src_compile
		popd
	fi
	distutils-r1_src_compile
}

python_compile() {
	filter-flags -ftracer -ftree-vectorize
	python_is_python3 || local -x CFLAGS="${CFLAGS} -fno-strict-aliasing"
	if use rust; then
		local -x HGWITHRUSTEXT="cpython"
	fi
	distutils-r1_python_compile build_ext --no-zstd
}

python_compile_all() {
	rm -r contrib/win32 || die
	emake doc
	if use chg; then
		emake -C contrib/chg
	fi
	if use emacs; then
		cd contrib || die
		elisp-compile mercurial.el || die "elisp-compile failed!"
	fi
}

src_install() {
	distutils-r1_src_install
}

python_install() {
	if use rust; then
		local -x HGWITHRUSTEXT="cpython"
	fi
	distutils-r1_python_install build_ext --no-zstd
}

python_install_all() {
	distutils-r1_python_install_all

	newbashcomp contrib/bash_completion hg

	if use zsh-completion ; then
		insinto /usr/share/zsh/site-functions
		newins contrib/zsh_completion _hg
	fi

	dobin hgeditor
	if use tk; then
		dobin contrib/hgk
	fi
	python_foreach_impl python_doscript contrib/hg-ssh

	if use emacs; then
		elisp-install ${PN} contrib/mercurial.el* || die "elisp-install failed!"
		elisp-site-file-install "${FILESDIR}"/${SITEFILE}
	fi

	local RM_CONTRIB=( hgk hg-ssh bash_completion zsh_completion plan9 *.el )

	if use chg; then
		dobin contrib/chg/chg
		doman contrib/chg/chg.1
		RM_CONTRIB+=( chg )
	fi

	for f in ${RM_CONTRIB[@]}; do
		rm -rf contrib/${f} || die
	done

	dodoc -r contrib
	docompress -x /usr/share/doc/${PF}/contrib
	doman doc/*.?
	dodoc CONTRIBUTORS hgweb.cgi

	insinto /etc/mercurial/hgrc.d
	doins "${FILESDIR}/cacerts.rc"
}

src_test() {
	pushd tests &>/dev/null || die
	rm -rf *svn*			# Subversion tests fail with 1.5
	rm -f test-archive*		# Fails due to verbose tar output changes
	rm -f test-convert-baz*		# GNU Arch baz
	rm -f test-convert-cvs*		# CVS
	rm -f test-convert-darcs*	# Darcs
	rm -f test-convert-git*		# git
	rm -f test-convert-mtn*		# monotone
	rm -f test-convert-tla*		# GNU Arch tla
	rm -f test-largefiles*		# tends to time out
	if [[ ${EUID} -eq 0 ]]; then
		einfo "Removing tests which require user privileges to succeed"
		rm -f test-convert*
		rm -f test-lock-badness*
		rm -f test-permissions*
		rm -f test-pull-permission*
		rm -f test-journal-exists*
		rm -f test-repair-strip*
	fi

	popd &>/dev/null || die
	distutils-r1_src_test
}

python_test() {
	local TEST_DIR

	rm -rf "${TMPDIR}"/test
	distutils_install_for_testing
	cd tests || die
	"${PYTHON}" run-tests.py --verbose \
		--tmpdir="${TMPDIR}"/test \
		--with-hg="${TEST_DIR}"/scripts/hg \
		|| die "Tests fail with ${EPYTHON}"
}

pkg_postinst() {
	use emacs && elisp-site-regen

	elog "If you want to convert repositories from other tools using convert"
	elog "extension please install correct tool:"
	elog "  dev-vcs/cvs"
	elog "  dev-vcs/darcs"
	elog "  dev-vcs/git"
	elog "  dev-vcs/monotone"
	elog "  dev-vcs/subversion"
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
