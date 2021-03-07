# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="Command-line interface to various pastebins"
HOMEPAGE="http://wgetpaste.zlin.dk/"

COMMIT_HASH="f9b08c50009485817e8b44300f79a92e37fe9f22"
SRC_URI="https://github.com/zlin/wgetpaste/archive/${COMMIT_HASH}.tar.gz -> ${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="+ssl"

RDEPEND="net-misc/wget[ssl?]"

S="${WORKDIR}/${PN}-${COMMIT_HASH}"

src_prepare() {
	sed -i -e "s:/etc:\"${EPREFIX}\"/etc:g" wgetpaste || die
	default
}

src_install() {
	dobin ${PN}
	insinto /usr/share/zsh/site-functions
	doins _wgetpaste
}
