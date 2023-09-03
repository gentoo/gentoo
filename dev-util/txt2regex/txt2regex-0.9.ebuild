# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A Regular Expression wizard that converts human sentences to regexs"
HOMEPAGE="https://aurelio.net/projects/txt2regex/"
SRC_URI="https://github.com/aureliojargas/txt2regex/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="nls cjk"

DEPEND="nls? ( sys-devel/gettext )"
RDEPEND=">=app-shells/bash-2.04"
RESTRICT="test" # tests need to run in a docker container it seems

src_prepare() {
	default

	# bug #93568
	if ! use nls ; then
		eapply "${FILESDIR}"/${P}-disable-nls.patch
	fi

	if use cjk ; then
		sed -i -e 's/\xa4/:+:/g' "${S}"/${PN}.sh || die
	fi
}

src_compile() {
	# a call to emake without target will execute the tests
	true
}

src_install() {
	emake DESTDIR="${ED}" MANDIR="${D}"/usr/share/man/man1 install
	dodoc CHANGELOG.md README.md TODO
	newman man/txt2regex.man txt2regex.6
}
