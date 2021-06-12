# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1 bash-completion-r1 vcs-snapshot prefix

DESCRIPTION="change directory command that learns"
HOMEPAGE="https://github.com/wting/autojump"
SRC_URI="https://github.com/wting/${PN}/archive/release-v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x64-macos"
IUSE="ipython test"
REQUIRED_USE="ipython? ( ${PYTHON_REQUIRED_USE} )"

RESTRICT="!test? ( test )"
RDEPEND="ipython? ( ${PYTHON_DEPS} )"
DEPEND="${PYTHON_DEPS}
	test? (
		>=dev-vcs/pre-commit-0.7.0[${PYTHON_SINGLE_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	eapply_user
	sed -e "s:/usr/local/share:/usr/share:" \
		-i bin/autojump.sh || die

	# autojump_argparse is only there for Python 2.6 compatibility
	sed -e "s:autojump_argparse:argparse:" \
		-i bin/autojump || die

	hprefixify -q '"' -w '/usr\/share/' bin/autojump.sh
}

src_compile() {
	:
}

src_install() {
	dobin bin/"${PN}"
	python_doscript "${ED}"/usr/bin/"${PN}"

	insinto /etc/profile.d
	doins bin/"${PN}".sh

	insinto /usr/share/"${PN}"/
	doins bin/"${PN}.bash"
	doins bin/"${PN}.zsh"
	doins bin/"${PN}.fish"
	insinto /usr/share/zsh/site-functions
	doins bin/_j

	python_domodule bin/autojump_argparse.py bin/autojump_data.py \
		bin/autojump_match.py bin/autojump_utils.py
	if use ipython; then
		python_domodule tools/autojump_ipython.py
	fi

	doman docs/"${PN}.1"
	einstalldocs
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
