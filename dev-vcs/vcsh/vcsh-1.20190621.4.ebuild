# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION='Manage config files in $HOME via fake bare git repositories'
HOMEPAGE="https://github.com/RichiH/vcsh/"

MY_PV="$(ver_rs 2 '-')"
SRC_URI="https://github.com/RichiH/vcsh/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( GPL-3 GPL-2 )"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RESTRICT="test"

RDEPEND="dev-vcs/git"
DEPEND=""

DOCS=( changelog README.md CONTRIBUTORS )

S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare() {
	default
	sed -i \
		-e 's,vendor-completions,site-functions,' \
		-e "s,\(\$(DOCDIR_PREFIX)\)/\$(self),\1/${PF}," \
		Makefile || die "sed failed"

	# remove dysfunctional tests
	sed -i -e 's,install: all,install:,' \
		Makefile || die "sed failed"
}

src_compile() {
	:
}

src_install() {
	default
	dodoc -r doc/sample_hooks
}
