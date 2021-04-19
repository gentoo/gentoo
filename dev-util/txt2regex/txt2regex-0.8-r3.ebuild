# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A Regular Expression wizard that converts human sentences to regexs"
HOMEPAGE="http://txt2regex.sourceforge.net/"
SRC_URI="http://txt2regex.sourceforge.net/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~mips ppc ppc64 sparc x86"
IUSE="nls cjk"

DEPEND="nls? ( sys-devel/gettext )"
RDEPEND=">=app-shells/bash-2.04"

PATCHES=(
	# bug #562856
	"${FILESDIR}"/${P}-textdomaindir.patch
)

src_prepare() {
	default

	# bug #93568
	if ! use nls ; then
		eapply "${FILESDIR}"/${P}-disable-nls.patch
	fi

	if use cjk ; then
		sed -i -e 's/\xa4/:+:/g' "${S}"/${P}.sh || die
	fi
}

src_install() {
	emake install DESTDIR="${ED}" MANDIR="${D}"/usr/share/man/man1 install
	dodoc Changelog NEWS README README.japanese TODO
	newman txt2regex.man txt2regex.6
}
