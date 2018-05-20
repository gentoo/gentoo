# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_REPO_URI="https://github.com/rwos/${PN}.git"
inherit git-r3

DESCRIPTION="A silly git launcher, basically. Inspired by sl"
HOMEPAGE="http://r-wos.org/hacks/gti"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
[[ ${PV} == 9999 ]] || \
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND="dev-vcs/git"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	# fix the makefile
	sed -i \
		-e "s:CC=:CC?=:g" \
		-e "s:CFLAGS=:CFLAGS?=:g" \
		-e "/-\$(STRIP)/d" \
		-e 's:$(CC):$(CC) $(LDFLAGS):' \
		Makefile || die
}

src_install() {
	dobin gti
}
