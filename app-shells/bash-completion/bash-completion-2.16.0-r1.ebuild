# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

BASHCOMP_P=bashcomp-2.0.3
PYTHON_COMPAT=( python3_{10..13} )

inherit autotools python-any-r1

DESCRIPTION="Programmable Completion for bash"
HOMEPAGE="https://github.com/scop/bash-completion"
SRC_URI="
	https://github.com/scop/bash-completion/releases/download/${PV}/${P}.tar.xz
	eselect? (
		https://github.com/projg2/bashcomp2/releases/download/v${BASHCOMP_P#*-}/${BASHCOMP_P}.tar.gz
	)
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="+eselect test"
RESTRICT="!test? ( test )"

# completion collision with net-fs/mc
RDEPEND="
	>=app-shells/bash-4.3_p30-r1:0
	sys-apps/miscfiles
	!<app-text/tree-2.1.1-r1
	!!net-fs/mc
"
BDEPEND="
	test? (
		${RDEPEND}
		$(python_gen_any_dep '
			dev-python/pexpect[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/pytest-xdist[${PYTHON_USEDEP}]
		')
	)
"
PDEPEND="
	>=app-shells/gentoo-bashcomp-20140911
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.14.0-optimize-kernel-modules.patch
	"${FILESDIR}"/${PN}-2.16.0-libsecret-completion.patch
)

strip_completions() {
	# Remove unwanted completions.
	local strip_completions=(
		# Slackware package stuff, quite generic names cause collisions
		# (e.g. with sys-apps/pacman)
		explodepkg installpkg makepkg pkgtool removepkg upgradepkg

		# Debian/Red Hat network stuff
		ifdown ifup ifquery ifstatus

		# Installed in app-editors/vim-core
		xxd

		# Now-dead symlinks to deprecated completions
		hd ncal

		# For GNU mailman, which isn't packaged. If mailman isn't installed,
		# it triggers a QA warning.
		arch
	)

	local file
	for file in "${strip_completions[@]}"; do
		rm "${ED}"/usr/share/bash-completion/completions/${file} ||
			die "stripping ${file} failed"
	done

	# remove deprecated completions (moved to other packages)
	rm "${ED}"/usr/share/bash-completion/completions/_* || die
}

python_check_deps() {
	python_has_version "dev-python/pexpect[${PYTHON_USEDEP}]" &&
	python_has_version "dev-python/pytest[${PYTHON_USEDEP}]" &&
	python_has_version "dev-python/pytest-xdist[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	if use eselect; then
		eapply "${WORKDIR}/${BASHCOMP_P}/bash-completion-blacklist-support.patch"
	fi

	default
	# Only needed for ${PN}-2.16.0-libsecret-completion.patch
	eautoreconf
}

src_test() {
	local EPYTEST_DESELECT=(
		# redhat-specific, we strip these completions
		test/t/test_if{down,up}.py
		# not available for icedtea
		test/t/test_javaws.py
		# TODO
		test/t/test_vi.py::TestVi::test_2
		test/t/test_xmlwf.py::TestXmlwf::test_2 #bug 886159
		test/t/test_xrandr.py::TestXrandr::test_output_filter
		test/t/unit/test_unit_dequote.py
		test/t/test_sudo.py::TestSudo::test_1 #bug 935400
		test/t/test_xfreerdp.py::TestXfreerdp::test_6 #bug 935400
		test/t/unit/test_unit_command_offset.py::TestUnitCommandOffset::test_cmd_quoted #bug 931744
		test/t/test_make.py::TestMake::test_6 #bug 931744
	)
	local EPYTEST_IGNORE=(
		# stupid test that async tests work
		test/fixtures/pytest/test_async.py
	)
	local EPYTEST_XDIST=1

	# portage's HOME override breaks tests
	local -x HOME=$(unset HOME; echo ~)
	addpredict "${HOME}"
	# used in pytest tests
	local -x NETWORK=none
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x PYTEST_PLUGINS=xdist.plugin
	emake -C completions check
	epytest
}

src_install() {
	# work-around race conditions, bug #526996
	mkdir -p "${ED}"/usr/share/bash-completion/{completions,helpers} || die

	emake DESTDIR="${D}" profiledir="${EPREFIX}"/etc/bash/bashrc.d install

	strip_completions

	dodoc AUTHORS CHANGELOG.md CONTRIBUTING.md README.md

	# install the python completions for all targets, bug #622892
	local TARGET
	for TARGET in "${PYTHON_COMPAT[@]}"; do
		if [[ ! -e "${ED}"/usr/share/bash-completion/completions/${TARGET/_/.} ]]; then
			dosym python "${ED}"/usr/share/bash-completion/completions/${TARGET/_/.}
		fi
	done

	# install the eselect module
	if use eselect; then
		insinto /usr/share/eselect/modules
		doins "${WORKDIR}/${BASHCOMP_P}/bashcomp.eselect"
		doman "${WORKDIR}/${BASHCOMP_P}/bashcomp.eselect.5"
	fi
}

pkg_postinst() {
	if has_version 'app-shells/zsh'; then
		elog
		elog "If you are interested in using the provided bash completion functions with"
		elog "zsh, valuable tips on the effective use of bashcompinit are available:"
		elog "  http://www.zsh.org/mla/workers/2003/msg00046.html"
		elog
	fi
}
