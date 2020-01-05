# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} )

inherit bash-completion-r1 python-r1 vcs-snapshot

DESCRIPTION="change directory command that learns"
HOMEPAGE="https://github.com/wting/autojump"
SRC_URI="https://github.com/wting/${PN}/archive/release-v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~mips ~ppc ~ppc64 ~x86 ~x64-macos"
IUSE="ipython test"
REQUIRED_USE="ipython? ( ${PYTHON_REQUIRED_USE} )"

# Not all tests pass. Need investigation.
RESTRICT="test"
RDEPEND="ipython? ( ${PYTHON_DEPS} )"
DEPEND="${PYTHON_DEPS}"

src_prepare() {
	eapply_user
	sed -e "s: \(/etc/profile.d\): \"${EPREFIX}\1\":" \
		-e "s:/usr/local/share:/usr/share:" \
		-i bin/autojump.sh || die

	# autojump_argparse is only there for Python 2.6 compatibility
	sed -e "s:autojump_argparse:argparse:" \
		-i bin/autojump || die
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

	python_foreach_impl python_domodule bin/autojump_argparse.py bin/autojump_data.py \
		bin/autojump_match.py bin/autojump_utils.py
	if use ipython; then
		python_foreach_impl python_domodule tools/autojump_ipython.py
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
