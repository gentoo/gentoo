# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit toolchain-funcs

DESCRIPTION="An easy to use text editor. A subset of aee"
#HOMEPAGE="http://mahon.cwx.net/ http://www.users.uswest.net/~hmahon/"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.src.tgz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ~mips ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

RDEPEND="!app-editors/ersatz-emacs"
S="${WORKDIR}/easyedit-${PV}"

PATCHES=(
	"${FILESDIR}"/${PN}-init-location.patch
	"${FILESDIR}"/${PN}-signal.patch
	"${FILESDIR}"/${PN}-Wformat-security.patch
	"${FILESDIR}"/${PN}-gcc-10.patch
)
DOCS=( Changes README.${PN} ${PN}.i18n.guide ${PN}.msg )

src_prepare() {
	sed -i \
		-e "s/make -/\$(MAKE) -/g" \
		-e "/^buildee/s/$/ localmake/" \
		Makefile

	sed -i \
		-e "s/\tcc /\t\\\\\$(CC) /" \
		-e "/CFLAGS =/s/\" >/ \\\\\$(LDFLAGS)\" >/" \
		-e "/other_cflag/s/ *-s//" \
		create.make

	default
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
	einstalldocs
	keepdir /usr/share/${PN}
}
