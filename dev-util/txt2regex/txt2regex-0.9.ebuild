# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A Regular Expression wizard that converts human sentences to regexs"
HOMEPAGE="https://aurelio.net/projects/txt2regex/"
SRC_URI="https://github.com/aureliojargas/txt2regex/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="nls cjk"
RESTRICT="test" # tests need to run in a docker container it seems

RDEPEND=">=app-shells/bash-2.04"
BDEPEND="nls? ( sys-devel/gettext )"

src_prepare() {
	default

	if use !nls ; then
		eapply "${FILESDIR}"/${P}-disable-nls.patch # bug #93568
	fi

	if use cjk ; then
		sed -e 's/\xa4/:+:/g' -i ${PN}.sh || die
	fi
}

src_compile() {
	# there is no building the program as it is a shell script
	# but calling without target will run the tests and fail
	:
}

src_install() {
	emake DESTDIR="${ED}" MANDIR="${D}"/usr/share/man/man1 install
	dodoc CHANGELOG.md README.md TODO
	newman man/txt2regex.man txt2regex.6
}
