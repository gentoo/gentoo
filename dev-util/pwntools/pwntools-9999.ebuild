# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
inherit bash-completion-r1 distutils-r1

DESCRIPTION="CTF framework and exploit development library"
HOMEPAGE="https://github.com/Gallopsled/pwntools"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Gallopsled/pwntools.git"
else
	SRC_URI="https://github.com/Gallopsled/pwntools/archive/${PV/_beta/beta}.tar.gz -> ${P}.gh.tar.gz"
	if [[ ${PV} != *_beta* ]] ; then
		KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
	fi
	S="${WORKDIR}/${PN}-${PV/_beta/beta}"
fi

LICENSE="MIT GPL-2+ BSD-2"
SLOT="0"

RDEPEND="
	${PYTHON_DEPS}
	>=dev-libs/capstone-3.0.5[python,${PYTHON_USEDEP}]
	>=dev-util/ROPgadget-5.3[${PYTHON_USEDEP}]
	>=dev-util/unicorn-1.0.2[python,${PYTHON_USEDEP}]
	dev-python/colored-traceback[${PYTHON_USEDEP}]
	>=dev-python/intervaltree-3.0[${PYTHON_USEDEP}]
	>=dev-python/mako-1.0.0[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	>=dev-python/paramiko-1.15.2[${PYTHON_USEDEP}]
	>=dev-python/psutil-3.3.0[${PYTHON_USEDEP}]
	>=dev-python/pyelftools-0.29[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.0[${PYTHON_USEDEP}]
	>=dev-python/pyserial-2.7[${PYTHON_USEDEP}]
	dev-python/PySocks[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	>=dev-python/requests-2.0[${PYTHON_USEDEP}]
	dev-python/rpyc[${PYTHON_USEDEP}]
	>=dev-python/six-1.12.0[${PYTHON_USEDEP}]
	dev-python/sortedcontainers[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/${PN}-4.11.0_update_deps.patch"
)

python_configure_all() {
	DISTUTILS_ARGS=(
		--only-use-pwn-command
	)
}

src_install() {
	distutils-r1_src_install

	newbashcomp extra/bash_completion.d/pwn pwn
	newbashcomp extra/bash_completion.d/shellcraft shellcraft

	insinto /usr/share/zsh/site-functions
	doins extra/zsh_completion/_pwn

	# Disable automatic update check (bug 915496).
	insinto /etc
	doins "${FILESDIR}/pwn.conf"

	rm -r "${ED}/usr/pwntools-doc" || die
}
