# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit bash-completion-r1 python-r1 vcs-snapshot

DESCRIPTION="change directory command that learns"
HOMEPAGE="https://github.com/joelthelion/autojump"
SRC_URI="https://github.com/joelthelion/${PN}/archive/release-v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="ipython test"
REQUIRED_USE="ipython? ( ${PYTHON_REQUIRED_USE} )"

# Not all tests pass. Need investigation.
RESTRICT="test"
RDEPEND="ipython? ( ${PYTHON_DEPS} )"
DEPEND="test? ( dev-python/flake8 dev-python/tox )"

PATCHES=(
	"${FILESDIR}/${P}-fix-autojump.fish-bugs.patch"
	"${FILESDIR}/${P}-fix-__aj_error-typo.patch"
)

src_prepare() {
	sed -e "s: \(/etc/profile.d\): \"${EPREFIX}\1\":" \
		-e "s:/usr/local/share:/usr/share:" \
		-i bin/autojump.sh || die

	# autojump_argparse is only there for Python 2.6 compatibility
	sed -e "s:autojump_argparse:argparse:" \
		-i bin/autojump || die

	# upstream fixes to the autojump.fish script; the first patch is needed for
	# the second patch to apply
	epatch "${PATCHES[@]}"
}

src_compile() {
	:
}

src_install() {
	dobin bin/"${PN}"
	python_replicate_script "${ED}"/usr/bin/"${PN}"

	insinto /etc/profile.d
	doins bin/"${PN}".sh

	insinto /usr/share/"${PN}"/
	doins bin/"${PN}.bash"
	doins bin/"${PN}.zsh"
	doins bin/"${PN}.fish"
	insinto /usr/share/zsh/site-functions
	doins bin/_j

	python_foreach_impl python_domodule bin/autojump_data.py bin/autojump_utils.py
	if use ipython; then
		python_foreach_impl python_domodule tools/autojump_ipython.py
	fi

	doman docs/"${PN}.1"
	dodoc README.md
}

pkg_postinst() {
	if use ipython; then
		elog 'This tool provides "j" for ipython, please add'
		elog '"import autojump_ipython" to your ipy_user_conf.py.'
		elog
	fi

	elog 'If you use app-shells/fish, add the following code to your'
	elog 'config.fish to get autojump support:'
	elog 'if test -f /usr/share/autojump/autojump.fish'
	elog '    source /usr/share/autojump/autojump.fish'
	elog 'end'
}
