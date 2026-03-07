# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CARGO_OPTIONAL=1
DISTUTILS_USE_PEP517="setuptools"
DISTUTILS_EXT=1
PYTHON_COMPAT=( python3_{10..14} )
PYTHON_REQ_USE="threads(+)"

inherit shell-completion cargo elisp-common distutils-r1 mercurial flag-o-matic multiprocessing

DESCRIPTION="Scalable distributed SCM"
HOMEPAGE="https://www.mercurial-scm.org/"
EHG_REPO_URI="https://www.mercurial-scm.org/repo/hg"

LICENSE="GPL-2+"
SLOT="0"
IUSE="+chg emacs gpg tk rust"

BDEPEND="
	dev-python/docutils[${PYTHON_USEDEP}]
	rust? ( ${RUST_DEPEND} )"

RDEPEND="
	dev-python/zstandard[${PYTHON_USEDEP}]
	app-misc/ca-certificates
	gpg? ( app-alternatives/gpg )
	tk? ( dev-lang/tk )"

DEPEND="emacs? ( >=app-editors/emacs-23.1:* )"

SITEFILE="70${PN}-gentoo.el"

RESTRICT="test"  # test suite needs mercurial to be installed

pkg_setup() {
	use rust && rust_pkg_setup
}

src_unpack() {
	mercurial_src_unpack
	if use rust; then
		local S="${S}/rust/hg-cpython"
		cargo_live_src_unpack
	else
		# Needed because distutils-r1 install under cargo_env if cargo is inherited
		cargo_gen_config
	fi
}

python_prepare_all() {
	# fix up logic that won't work in Gentoo Prefix (also won't outside in
	# certain cases), bug #362891
	sed -i -e 's:xcodebuild:nocodebuild:' setup.py || die
	sed -i -e 's/__APPLE__/__NO_APPLE__/g' mercurial/cext/osutil.c || die

	# Build assumes the Rust target directory, which is wrong for us.
	sed -i -r "s:\brust[/,' ]+target[/,' ]+release\b:rust/$(cargo_target_dir):g" setup.py || die

	distutils-r1_python_prepare_all
}

python_configure_all() {
	cat >> setup.cfg <<-EOF || die
		[build_ext]
		rust = $(usex rust True False)
		zstd = False
	EOF
}

src_compile() {
	if use rust; then
		pushd rust/hg-cpython || die
		cargo_src_compile --no-default-features --jobs $(makeopts_jobs)
		popd || die
	fi
	distutils-r1_src_compile
}

python_compile() {
	filter-flags -ftracer -ftree-vectorize
	distutils-r1_python_compile build_ext
}

python_compile_all() {
	rm -r contrib/win32 || die
	emake doc
	if use chg; then
		emake -C contrib/chg
	fi
	if use rust; then
		pushd rust/rhg || die
		cargo_src_compile --no-default-features --jobs $(makeopts_jobs)
		popd || die
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
	distutils-r1_python_install build_ext
	python_doscript contrib/hg-ssh
}

python_install_all() {
	distutils-r1_python_install_all

	newbashcomp contrib/bash_completion hg
	newzshcomp contrib/zsh_completion _hg

	dobin hgeditor
	if use tk; then
		dobin contrib/hgk
	fi

	if use emacs; then
		elisp-install ${PN} contrib/mercurial.el* || die "elisp-install failed!"
		elisp-make-site-file "${SITEFILE}"
	fi

	local RM_CONTRIB=( hgk hg-ssh bash_completion zsh_completion plan9 *.el )

	if use chg; then
		dobin contrib/chg/chg
		doman contrib/chg/chg.1
		RM_CONTRIB+=( chg )
	fi
	if use rust; then
		dobin "rust/$(cargo_target_dir)/rhg"
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

pkg_postinst() {
	use emacs && elisp-site-regen

	elog "If you want to convert repositories from other tools using"
	elog "the convert extension please install the correct tool:"
	elog "  dev-vcs/cvs"
	elog "  dev-vcs/darcs"
	elog "  dev-vcs/git"
	elog "  dev-vcs/monotone"
	elog "  dev-vcs/subversion"
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
