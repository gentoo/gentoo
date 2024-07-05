# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Tool for editing VCS repositories and translating among different systems"
HOMEPAGE="http://www.catb.org/~esr/reposurgeon/"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://gitlab.com/esr/reposurgeon.git"
	inherit git-r3
else
	SRC_URI="http://www.catb.org/~esr/${PN}/${P}.tar.xz"
# This server is not accessible from the Internet. Delete this comment
# and line below it, and follow the directions in the next comment
#	SRC_URI+=" http://ardvarc.coronya.com/~salahx/${P}-vendor.tar.xz"
# Fill the URL in with the generated Go depenency tarball.
	SRC_URI+=" http://dev.gentoo.org/~whoever/../${P}-vendor.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

inherit go-module

LICENSE="BSD-2"
SLOT="0"
IUSE="test"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	app-text/xmlto
	app-text/asciidoc
	dev-ruby/asciidoctor"

BDEPEND="test? ( dev-vcs/subversion
		|| (	dev-util/shellcheck-bin
			dev-util/shellcheck )
	)"

PATCHES=(
	"${FILESDIR}/${PN}-5.3-disable-obsolete-golint.patch"
)

RESTRICT="!test? ( test )"

src_unpack() {
	if [[ ${PV} == "9999" ]]; then
		git-r3_src_unpack
		go-module_live_vendor
	else
		default
	fi
}

src_prepare() {
	default
	sed -e 's/GOFLAGS/MY_GOFLAGS/g' \
	    -i "${S}/Makefile" || die
}

src_compile() {
	GOFLAGS="-mod=vendor" emake all
}

src_install() {
	emake DESTDIR="${ED}" prefix="/usr" docdir="share/doc/${P}" install
}
