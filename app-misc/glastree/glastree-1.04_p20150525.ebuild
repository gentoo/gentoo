# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT="1dc111308356d999f2a32aa50b6a0737ec5e6b09"
DESCRIPTION="glastree is a poor mans snapshot utility using hardlinks written in perl"
HOMEPAGE="https://old.igmus.org/code/"
SRC_URI="https://github.com/jeremywohl/glastree/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-lang/perl
	dev-perl/Date-Calc
"
BDEPEND="test? ( ${RDEPEND} )"

PATCHES=(
	"${FILESDIR}"/${PN}-posix-make.patch
)

src_compile() { :; }

src_install() {
	dodir /usr/share/man/man1
	emake INSTROOT="${ED}"/usr INSTMAN=share/man install
	dodoc README CHANGES THANKS
}
